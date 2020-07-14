import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;


final FirebaseAuth _auth = FirebaseAuth.instance;
class Auth {
    static FirebaseUser user;

    static void setupIntercept() {
        getInitialUri().then((link) => Auth.interceptLink(link));
        getUriLinksStream().listen((link) => Auth.interceptLink(link));
    }

    static void interceptLink(Uri link) {
        if(link != null) {
            print("Got link");
            print(link);
        }
    }

    static Future<String> signIn(String email, String password) async {
        final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
        user = authResult.user;
        return 'Sign in succeeded: $user.email';
    }

    static void signOut() async{
        await _auth.signOut();
        user = null;
        print("User Sign Out");
    }
}



