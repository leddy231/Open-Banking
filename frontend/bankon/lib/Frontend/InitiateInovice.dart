import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../backend/Backend.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'package:calendarro/calendarro.dart';

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

  TextEditingController _NameBankonTextEditingController;
  TextEditingController _BankonIdTextEditingController;
  TextEditingController _NameRegularTextEditingController;
  TextEditingController _OrgNrTextEditingController;
  TextEditingController _ReferenceTextEditingController;
  TextEditingController _PhoneTextEditingController;
  TextEditingController _EmailTextEditingController;
  TextEditingController _COTextEditingController;
  TextEditingController _AdressTextEditingController;
  TextEditingController _PostalCodeTextEditingController;
  TextEditingController _CityTextEditingController;
  TextEditingController _countryTextEditingController;

  @override
  void initState() {
    super.initState();
    _focusNodeReciver = new FocusNode();
    _focusNodeReciver.addListener(_onFocusNodeRecieverEvent);
    _NameBankonTextEditingController = new TextEditingController();
    _BankonIdTextEditingController = new TextEditingController();
    _NameRegularTextEditingController = new TextEditingController();
    _OrgNrTextEditingController = new TextEditingController();
    _ReferenceTextEditingController = new TextEditingController();
    _PhoneTextEditingController = new TextEditingController();
    _EmailTextEditingController = new TextEditingController();
    _COTextEditingController = new TextEditingController();
    _AdressTextEditingController = new TextEditingController();
    _PostalCodeTextEditingController = new TextEditingController();
    _CityTextEditingController = new TextEditingController();
    _countryTextEditingController = new TextEditingController();
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
            Calendarro(
              startDate: DateTime.parse('2012-02-27'),
              endDate: DateTime.now(),
              displayMode: DisplayMode.MONTHS,
              selectionMode: SelectionMode.MULTI,
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
            ),
            SizedBox(
              height: 3,

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
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Contact>> snapshot) {
                          if (snapshot.hasData) {
                            Contacts = snapshot.data;
                            if (Contacts.length == 0) {
                              return Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "No Contacts Found",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
                            return Column(children: <Widget>[
                              CircularProgressIndicator()
                            ]);
                          }
                        })),
              ),
              Container(
                child: Text("Register Bankon Recipient"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightGreen)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _NameBankonTextEditingController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "Name",
                            focusColor: Colors.lightGreen,
                          ),
                        ),
                        TextFormField(
                          controller: _BankonIdTextEditingController,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "Bankon Id",
                            focusColor: Colors.lightGreen,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text("Register Regular Recipient"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightGreen)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: _NameRegularTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          hintText: "Name",
                          focusColor: Colors.lightGreen,
                        ),
                      ),
                      TextFormField(
                        controller: _OrgNrTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Org Nr",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _ReferenceTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "Reference",
                            focusColor: Colors.lightGreen,
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightGreen))),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _PhoneTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _EmailTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "E-Mail",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _COTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "C/O",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _AdressTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Adress",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _PostalCodeTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Postal Code",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _CityTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "City",
                          focusColor: Colors.lightGreen,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      TextFormField(
                        onTap: () {},
                        controller: _countryTextEditingController,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Country",
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
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
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
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget Costs() {
    return Container(
      child: Text("hej"),
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
      title: Text("Specify Work Days"),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget CostAppbar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/InovicePage');
        },
        child: Icon(Icons.keyboard_backspace),
      ),
      elevation: 5,
      title: Text("Specify Costs"),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget appbarSelect(int stateHolder) {
    if (stateHolder == 0) {
      return recipientAppBar();
    } else if (stateHolder == 1) {
      return specificationsAppbar();
    } else if (stateHolder == 2) {
      return CostAppbar();
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
    } else if (stateHolder == 2) {
      return Costs();
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
