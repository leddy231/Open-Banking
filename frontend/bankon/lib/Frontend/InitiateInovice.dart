import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend/Auth.dart';
import '../backend/Account.dart';
import '../backend/Backend.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'AccountDataPage.dart';
import 'BankDataPage.dart';

final Color backgroundColor = Colors.white;

class InitInovice extends StatefulWidget {
  @override
  _InitInoviceState createState() => _InitInoviceState();
}

class _InitInoviceState extends State<InitInovice>
    with SingleTickerProviderStateMixin {
  int stateHolder = 0;

//Todo Uppdate this once UserClassAdded
  Contact SelectedContact;
  List<Contact> Contacts;

  double screenWidth, screenHeigh;
  FocusNode _focusNodeReciver;
  TextEditingController _recieverTextController;
  TextEditingController _ocrTextController;
  TextEditingController _amountTextController;
  TextEditingController _dateTextController;
  TextEditingController _senderTextController;
  TextEditingController _noteTextController;

  @override
  void initState() {
    super.initState();
    _focusNodeReciver = new FocusNode();
    _focusNodeReciver.addListener(_onFocusNodeRecieverEvent);
    _recieverTextController = new TextEditingController();
    _ocrTextController = new TextEditingController();
    _dateTextController = new TextEditingController();
    _amountTextController = new TextEditingController();
    _senderTextController = new TextEditingController();
    _noteTextController = new TextEditingController();
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
            child: appbarSelect(stateHolder)),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: bodySelect(stateHolder));
  }

  Widget specificationBody() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 40,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.greenAccent,
                color: Colors.lightGreen,
                elevation: 1.0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      stateHolder++;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Next',
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
            Container(
              height: 40,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.greenAccent,
                color: Colors.lightGreen,
                elevation: 1.0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      stateHolder--;
                    });
                  },
                  child: Center(
                    child: Text(
                      'back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget recipientBody() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen)),
                    width: 350,
                    child: StreamBuilder(
                        stream: Database.contacts(),
                        builder:
                            (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
                          if (snapshot.hasData) {
                            Contacts = snapshot.data;
                            if(Contacts.length == 0){
                              return Padding(
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Text("No Contacts Found",style: TextStyle(
                                  fontSize: 20,
                                ),textAlign: TextAlign.center,),
                              );
                            }
                            return DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<Contact>(
                                  value: SelectedContact,
                                  hint: Text("Saved Contacts"),
                                  onChanged: (Contact newValue) {
                                    setState(() {
                                      SelectedContact = newValue;
                                    });
                                  },
                                  items: Contacts.map((Contact contact) {
                                    return DropdownMenuItem<Contact>(
                                      value: contact,
                                      child: Text(contact.name),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                                children: <Widget>[CircularProgressIndicator()]);
                          }
                        })),
              ),
              SizedBox(
                height: 450,
              ),
              Container(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.lightGreen,
                    elevation: 1.0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          stateHolder++;
                        });
                      },
                      child: Center(
                        child: Text(
                          'Next',
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
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget recipientBody1() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(children: <Widget>[
                        TextFormField(
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
                        TextFormField(
                          controller: _ocrTextController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: "OCR",
                            focusColor: Colors.lightGreen,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _amountTextController,
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
                        TextFormField(
                          onTap: () {},
                          controller: _dateTextController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            hintText: "Date",
                            focusColor: Colors.lightGreen,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _senderTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              hintText: "Supply Sender Account",
                              focusColor: Colors.lightGreen,
                            ),
                          ),
                          TextFormField(
                            controller: _noteTextController,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              hintText: "Personal Note",
                              focusColor: Colors.lightGreen,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.lightGreen,
                      elevation: 1.0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            stateHolder++;
                          });
                        },
                        child: Center(
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget recipientAppBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/InovicePage');
        },
        child: Icon(Icons.keyboard_backspace),
      ),
      elevation: 5,
      title: Text("Add Recipient"),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget specificationsAppbar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/InovicePage');
        },
        child: Icon(Icons.keyboard_backspace),
      ),
      elevation: 5,
      title: Text("Specify Work"),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget appbarSelect(int stateHolder) {
    if (stateHolder == 0) {
      return recipientAppBar();
    } else if (stateHolder == 1) {
      return specificationsAppbar();
    } else
      return AppBar(
        leading: Text("ERROR"),
      );
  }

  Widget bodySelect(int stateHolder) {
    if (stateHolder == 0) {
      return recipientBody();
    } else if (stateHolder == 1) {
      return specificationBody();
    }
  }
}

abstract class ListContactItem {
  Widget buildContactItem(BuildContext context);
}

class contactItem implements ListContactItem {
  final Contact contactData;

  contactItem(this.contactData);

  Contact getContactData() {
    return contactData;
  }

  @override
  Widget buildContactItem(BuildContext context) {
    return Container();
  }
}
