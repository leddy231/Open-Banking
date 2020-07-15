import './settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgotPassword.dart';
import 'signup.dart';
import 'menuDashbordLayout.dart';
import 'BankSelectionPage.dart';
import 'BankDataPage.dart';
import '../backend/Auth.dart';

void main() {
  runApp(new BankonApp());
  Auth.setup();
}

//Todo: Firebase loggin.
class BankonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context) => new MainLoginPage(),
        '/resetPass': (BuildContext context) => new resetPass(),
        '/menu': (BuildContext context) => new MenuDashbord(),
        '/bankSelect': (BuildContext context) => new bankList(),
        '/settings': (BuildContext context) => new settings(),
        '/BankDataPage': (BuildContext context) => new BankData(),
        '/startPage': (BuildContext context) => new BankonApp()
      },
      home: new MainLoginPage(),
    );
  }
}

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => new _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  var logginStatus = "hej";
  var logginStatusVisible = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordTextController.dispose();
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            FirebaseUser user = snapshot.data;
            if (user == null) {
              return logginScreen(context);
            } else {
              return MenuDashbord();
            }
          }
          return logginScreen(context);
        },
      ),
    );
  }

  Widget logginScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 110.0, 0.0, 0.0),
                child: Text(
                  'Hello',
                  style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(31.0, 175.0, 0.0, 0.0),
                child: Text(
                  'There',
                  style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                child: Text(
                  '.',
                  style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 35, left: 35, right: 40),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordTextController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 5.0),
              Container(
                alignment: Alignment(1.0, 0.0),
                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/resetPass');
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 25,
                child: Visibility(
                  child: Text(
                    logginStatus,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                  visible: logginStatusVisible,
                ),
              ),
              Container(
                height: 60.0,
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  elevation: 7.0,
                  child: InkWell(
                    onTap: () {
                      getAuthSignIn();
                    },
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                  height: 60.0,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage('assets/BankId.png'),
                              color: null,
                              height: 40.0,
                              width: 40.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Center(
                            child: Text(
                              'Log in with BankID',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Monserrat',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'New to Bankon?',
              style: TextStyle(
                fontFamily: 'Monserrat',
              ),
            ),
            SizedBox(width: 5.0),
            InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Monserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.lightGreen,
                  ),
                ))
          ],
        ),
      ],
    );
  }

  getAuthSignIn() async {
     LoginStatus recived = await Auth.signIn(
        _emailTextController.text, _passwordTextController.text);

    setState(() {
      logginStatus = recived.show();
      logginStatusVisible = true;
    });
  }
}
