import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend/Auth.dart';
import '../backend/Account.dart';
import '../backend/Backend.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'AccountDataPage.dart';

final Color backgroundColor = Colors.white;

class InitTransaction extends StatefulWidget {
  @override
  _InitTransactionState createState() => _InitTransactionState();
}

class _InitTransactionState extends State<InitTransaction>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeigh;
  FocusNode _focusNodeReciver;
  TextEditingController _recieverTextController;

  @override
  void initState() {
    super.initState();
    _focusNodeReciver = new FocusNode();
    _focusNodeReciver.addListener(_onFocusNodeRecieverEvent);
    _recieverTextController = new TextEditingController();
  }

  _onFocusNodeRecieverEvent() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeigh = size.height;
    screenWidth = size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            elevation: 5,
            title: Text("Pay & Transfer"),
            backgroundColor: Colors.lightGreen,
          ),
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: TextFormField(
                            controller: _recieverTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              hintText:
                                  "Supply Reciever Account, bg- or pg-number",
                              focusColor: Colors.lightGreen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: _recieverTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              hintText: "OCR",
                              focusColor: Colors.lightGreen,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: _recieverTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintText: "Amount",
                                focusColor: Colors.lightGreen,
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: _recieverTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              hintText: "Date",
                              focusColor: Colors.lightGreen,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
