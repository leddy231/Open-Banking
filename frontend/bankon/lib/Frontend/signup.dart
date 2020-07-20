import 'package:flutter/material.dart';
import '../backend/Auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();
  final _emailConfirmTextController = TextEditingController();
  var ErrorString = "hej";
  var ErrorStringVisible = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _passwordConfirmTextController.dispose();
    _emailConfirmTextController.dispose();
    super.dispose();
  }

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
                      'Signup',
                      style: TextStyle(
                          fontSize: 70.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(250.0, 110.0, 0.0, 0.0),
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
                    controller: _emailConfirmTextController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Email',
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
                  TextFormField(
                    controller: _passwordConfirmTextController,
                    decoration: InputDecoration(
                      labelText: 'Comfirm Password',
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
                  SizedBox(height: 35.0),
                  Container(
                    height: 25,
                    child: Visibility(
                      child: Text(
                        ErrorString,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      visible: ErrorStringVisible,
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
                          if (_passwordConfirmTextController.text !=
                                  _passwordTextController.text ||
                              _emailConfirmTextController.text !=
                                  _emailTextController.text) {
                            setState(() {
                              ErrorString = "Password or Email is not matching";
                              ErrorStringVisible = true;
                            });
                          } else {
                            getAuthRegister();
                          }
                        },
                        child: Center(
                          child: Text(
                            'Register',
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
                  SizedBox(height: 20),
                  Container(
                      height: 60.0,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/login');
                        },
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
                                child: Text(
                                  'Go Back',
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
          ],
        ));
  }

  getAuthRegister() async {
    print("pressed register");
    RegisterStatus recived = await Auth.register(
        _emailTextController.text, _passwordTextController.text);

    if (recived.show() == 'Register Successful') {
      Navigator.of(context).pushNamed('/login');
    }

    setState(() {
      ErrorString = recived.show();
      ErrorStringVisible = true;
    });
  }
}
