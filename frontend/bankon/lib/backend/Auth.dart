import 'package:firebase_auth/firebase_auth.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth {
    static FirebaseUser user;

    static Future<String> signIn(String email, String password) async {
        final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
        user = authResult.user;
        return 'Sign in succeeded: $user.email';
    }

    static void signOut() async{
        await _auth.signOut();
        print("User Sign Out");
    }
}



