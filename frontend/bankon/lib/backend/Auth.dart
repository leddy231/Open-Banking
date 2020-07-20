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

enum RegisterStatus {
  invalidInput,
  invalidEmail,
  weakPassword,
  userExists,
  success,
  error
}

extension loginToString on LoginStatus {
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

extension registerToString on RegisterStatus {
  String show() {
    switch (this) {
      case RegisterStatus.invalidInput:
        return "Password and Email fields must be filled in";
      case RegisterStatus.userExists:
        return "This email is already in use";
      case RegisterStatus.invalidEmail:
        return "The email address is badly formatted.";
      case RegisterStatus.weakPassword:
        return "The password is too weak";
      case RegisterStatus.success:
        return "Register Successful";
      default:
        return "An error has occurred";
    }
  }
}

class Auth {
  static FirebaseUser user;

  static void setup() {
    getInitialUri().then((link) => Auth.interceptLink(link));
    getUriLinksStream().listen((link) => Auth.interceptLink(link));
  }

  static Stream<List<Account>> accounts() {
    if (user == null) {
      return Stream.empty();
    }
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('accounts')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Account.fromJson(doc.data))
            .toList());
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
    if (email == null || password == null || email == '' || password == '') {
      return LoginStatus.invalidInput;
    }
    try {
      final AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = authResult.user;
    } catch (e) {
      switch (e.code) {
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
    print('Sign in succeeded: $user.email');
    return LoginStatus.success;
  }

  ///   • `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
  ///   • `ERROR_INVALID_EMAIL` - If the email address is malformed.
  ///   • `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
  static Future<RegisterStatus> register(String email, String password) async {
    if (email == null || password == null || email == '' || password == '') {
      return RegisterStatus.invalidInput;
    }
    try {
      final AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = authResult.user;
    } catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          return RegisterStatus.weakPassword;
        case 'ERROR_INVALID_EMAIL':
          return RegisterStatus.invalidEmail;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return RegisterStatus.userExists;
        default:
          return RegisterStatus.error;
      }
    }
    return RegisterStatus.success;
  }

  static void signOut() async {
    await _auth.signOut();
    user = null;
    print("User Sign Out");
  }
}
