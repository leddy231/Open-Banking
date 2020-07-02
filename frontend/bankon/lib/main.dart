import 'package:flutter/material.dart';

import 'forgotPassword.dart';
import 'signup.dart';
import 'menuDashbordLayout.dart';

void main() => runApp(new BankonApp());

class BankonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context) => MainLoginPage(),
        '/resetPass': (BuildContext context) => new resetPass(),
        '/menu': (BuildContext context) => new MenuDashbord(),
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Hello',
                      style: TextStyle(
                          fontSize: 70.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(31.0, 175.0, 0.0, 0.0),
                    child: Text(
                      'There',
                      style: TextStyle(
                          fontSize: 70.0, fontWeight: FontWeight.bold),
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
                  TextField(
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
                  SizedBox(height: 35.0),
                  Container(
                    height: 60.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/menu');
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
            )
          ],
        ));
  }
}
