import 'package:bankon/backend/Backend.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new BankonApp());
  Backend.setup();
  Auth.signIn("test@test.com", "testtest");
}

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
                    Text(user.email),
                    FutureBuilder<List<Bank>>(
                      future: Database.getBanks(),
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
                              stream: Database.bankAccounts(),
                              builder: (context, snapshot) => Column(
                                children: snapshot.data
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () => Backend.getAccounts(e),
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
                            ),StreamBuilder<List<Account>>(
                              stream: Database.accounts(),
                              builder: (context, snapshot) => Column(
                                children: snapshot.data
                                    .map(
                                      (e) => GestureDetector(
                                    onTap: () async {
                                      print('ello');
                                      Database.transactions(e).listen(print);
                                      //String url = await Backend.getConsent(e.bank.account);
                                      //launch(url);
                                    },
                                    child: Row(
                                      children: [
                                        Text(e.id),
                                        Text(e.bank.account.consent.toString())
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
