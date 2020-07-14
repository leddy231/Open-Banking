import 'package:flutter/material.dart';
import '../backend/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
    runApp(new BankonApp());
}
//adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://bankon.leddy231.se/test"'

class BankonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MainLoginPage(),
    );
  }
}

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => new _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Text("Hello"),
          RaisedButton(
                child: Text('Login'),
                onPressed: () => Auth.signIn("test@test.com", "testtest"),
            ),
            RaisedButton(
                child: Text('Logout'),
                onPressed: () => Auth.signOut(),
            ),
          StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                FirebaseUser user = snapshot.data;
                if (user == null) {
                  return Text("Not logged in");
                }
                return Text(user.email);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
