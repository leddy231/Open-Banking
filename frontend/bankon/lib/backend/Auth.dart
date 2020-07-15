import 'package:bankon/backend/Backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_links/uni_links.dart';
import './Account.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
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
        if(link == null) {
            return;
        }
        if(user == null) {
            print("Got link but not logged in");
            return;
        }
        if(link.pathSegments.length > 0 && link.pathSegments[0] == 'auth') {
            String code = link.queryParameters['code'];
            String bank = link.queryParameters['bank'];
            final gettoken = Backend.post('/token', {'bank': bank, 'code': code});
            final usertoken = await user.getIdToken();
            final accesstoken = (await gettoken)['accesstoken'];
            Backend.post('/accounts', {'bank': bank, 'accesstoken': accesstoken, 'firebasetoken': usertoken.token});
        }
    }

    static Future<String> signIn(String email, String password) async {
        final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
        user = authResult.user;
        if(_accountsubscription != null) {
          _accountsubscription.cancel();
        }
        final accountstream = Firestore.instance.collection('users').document(user.uid).collection('accounts').snapshots();
        _accountsubscription = accountstream.listen((snapshot) {
          final accounts = snapshot.documents.map((doc) => Account.fromJson(doc.data));
          _accountscontroller.add(accounts.toList());
        });
        print('Sign in succeeded: $user.email');
        return 'Sign in succeeded: $user.email';
    }

    static void signOut() async{
        await _auth.signOut();
        user = null;
        print("User Sign Out");
    }
}



