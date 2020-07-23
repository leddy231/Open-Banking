import 'package:bankon/backend/Backend.dart';
import 'package:flutter/material.dart';
import '../backend/Auth.dart';
import '../backend/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new BankonApp());
  Auth.setup();
  Auth.signIn("test@test.com", "testtest");
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
          StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                FirebaseUser user = snapshot.data;
                if (user == null) {
                  return Text("Not logged in");
                }
                return Column(
                  children: [
                    Text('Yeet'),
                    Text(user.email),
                    FutureBuilder<List<Bank>>(
                      future: Backend.getBanks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(children: [
                            Column(
                              children: snapshot.data
                                  .map((Bank bank) => GestureDetector(
                                      onTap: () => launch(bank.redirecturl),
                                      child: Text(bank.name)))
                                  .toList(),
                            ),
                            StreamBuilder<List<BankAccount>>(
                              stream: Auth.userbanks(),
                              builder: (context, snapshot) => Column(
                                children: snapshot.data
                                    .map(
                                      (e) => GestureDetector(
                                        child: Row(
                                          children: [
                                            Text(e.bank.name),
                                            Text(e.accesstoken),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              initialData: [],
                            )
                          ]);
                        }
                        return Text("Waiting for banks");
                      },
                    )
                  ],
                );
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
