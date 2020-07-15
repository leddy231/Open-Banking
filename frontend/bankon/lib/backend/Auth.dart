import 'package:bankon/backend/Backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_links/uni_links.dart';
import './Account.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;

enum LoginStatus {
  invalidInput,
  invalidEmail,
  invalidPassword,
  invalidUser,
  userDisabled,
  success,
  error
}

extension toS on LoginStatus {
  String show() {
    switch (this) {
      case LoginStatus.invalidInput:
        return "Password and Email fields must be filled in";
      case LoginStatus.invalidEmail:
        return "The email address is badly formatted.";
      case LoginStatus.invalidPassword:
      case LoginStatus.invalidUser:
        return "E-mail address or password is incorrect.";
      case LoginStatus.userDisabled:
        return "This user is disabled";
      case LoginStatus.success:
        return "Login Successful";
      default:
        return "An error has occurred";
    }
  }
}

class Auth {
  static FirebaseUser user;
  static Stream<List<Account>> accounts;
  static StreamController<List<Account>> _accountscontroller;
  static StreamSubscription<QuerySnapshot> _accountsubscription;

  static void setup() {
    Auth.signIn('test@test.com', 'testtest');
    getInitialUri().then((link) => Auth.interceptLink(link));
    getUriLinksStream().listen((link) => Auth.interceptLink(link));
    _accountscontroller = StreamController();
    accounts = _accountscontroller.stream;
  }

  static void interceptLink(Uri link) async {
    if (link == null) {
      return;
    }
    if (user == null) {
      print("Got link but not logged in");
      return;
    }
    if (link.pathSegments.length > 0 && link.pathSegments[0] == 'auth') {
      String code = link.queryParameters['code'];
      String bank = link.queryParameters['bank'];
      final gettoken = Backend.post('/token', {'bank': bank, 'code': code});
      final usertoken = await user.getIdToken();
      final accesstoken = (await gettoken)['accesstoken'];
      Backend.post('/accounts', {
        'bank': bank,
        'accesstoken': accesstoken,
        'firebasetoken': usertoken.token
      });
    }
  }

  ///   • `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
  ///   • `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
  ///   • `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
  ///   • `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
  ///   • `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
  ///   • `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  static Future<LoginStatus> signIn(String email, String password) async {
    if(email == null || password == null) {
      return LoginStatus.invalidInput;
    }
    try {
      final AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = authResult.user;
    } catch (e) {
      switch (e) {
        case 'ERROR_INVALID_EMAIL':
          return LoginStatus.invalidEmail;
        case 'ERROR_WRONG_PASSWORD':
          return LoginStatus.invalidPassword;
        case 'ERROR_USER_NOT_FOUND':
          return LoginStatus.invalidUser;
        case 'ERROR_USER_DISABLED':
          return LoginStatus.userDisabled;
        default:
          return LoginStatus.error;
      }
    }

    if (_accountsubscription != null) {
      _accountsubscription.cancel();
    }
    final accountstream = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('accounts')
        .snapshots();
    _accountsubscription = accountstream.listen((snapshot) {
      final accounts =
          snapshot.documents.map((doc) => Account.fromJson(doc.data));
      _accountscontroller.add(accounts.toList());
    });
    print('Sign in succeeded: $user.email');
    return LoginStatus.success;
  }

  static void signOut() async {
    await _auth.signOut();
    user = null;
    print("User Sign Out");
  }
}
