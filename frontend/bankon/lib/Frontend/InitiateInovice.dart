import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../backend/Backend.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

final Color backgroundColor = Colors.white;

class InitInovice extends StatefulWidget {
  @override
  _InitInoviceState createState() => _InitInoviceState();
}

class _InitInoviceState extends State<InitInovice>
    with SingleTickerProviderStateMixin {
  int stateHolder = 0;

//Todo Uppdate this once UserClassAdded

  String TotalCost = "0";

  double MomsRate = 1.25;
  String SelectedMomsRateString = "25 %";
  List<String> MomsRatesString = ["25 %", "12 %", "6 %"];

  Contact SelectedContact;
  List<Contact> Contacts;
  List<DateTime> _SelectedDays;

  double screenWidth, screenHeigh;
  FocusNode _focusNodeReciver;
  CalendarController _calendarController;
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
  TextEditingController _serviceCostController;

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
    _calendarController = new CalendarController();
    _serviceCostController = new TextEditingController();

    _SelectedDays = [];
  }

  _onFocusNodeRecieverEvent() {
    setState(() {});
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List Days) {
    setState(() {
      _SelectedDays.add(day);
    });
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            calendarController: _calendarController,
            onDaySelected: _onDaySelected,
          ),
          ListView.builder(
            itemCount: _SelectedDays.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          child: Text(dateFormatting(_SelectedDays[index]))),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            shadowColor: Colors.greenAccent,
                            color: Colors.lightGreen,
                            elevation: 1.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _SelectedDays.removeAt(index);
                                });
                              },
                              child: Text("  remove date  "),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                  SizedBox(
                    height: 5,
                  )
                ],
              );
            },
          ),
          SizedBox(
            height: 20,
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
      ),
    );
  }

  Widget recipientBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.lightGreen)),
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
                        return Column(
                            children: <Widget>[CircularProgressIndicator()]);
                      }
                    })),
          ),
          Container(
            child: Text("Register Bankon Recipient"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.lightGreen)),
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
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.lightGreen)),
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
                            borderSide: BorderSide(color: Colors.lightGreen))),
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
    );
  }

  Widget Costs() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  if (text.length == 0) {
                    TotalCost = "0";
                  } else {
                    TotalCost =
                        (double.parse(text) * MomsRate).toStringAsFixed(2);
                  }
                });
              },

              textAlign: TextAlign.center,
              decoration:
                  new InputDecoration(labelText: "Enter Service Cost Ex Moms"),
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: _serviceCostController,
              inputFormatters: [
                DecimalTextInputFormatter()
              ], // Only numbers can be entered
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text("Select Service Cost rate"),
          ),
          SizedBox(
            height: 10,
          ),
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: SelectedMomsRateString,
                hint: Text("Moms Rate"),
                onChanged: (String newValue) {
                  setState(() {
                    SelectedMomsRateString = newValue;
                    if (SelectedMomsRateString == "25 %") {
                      MomsRate = 1.25;
                    } else if (SelectedMomsRateString == "12 %") {
                      MomsRate = 1.12;
                    } else {
                      MomsRate = 1.06;
                    }
                    if (_serviceCostController.text.length == 0) {
                      TotalCost = "0";
                    } else {
                      TotalCost =
                          (double.parse(_serviceCostController.text) * MomsRate)
                              .toStringAsFixed(2);
                    }
                  });
                },
                items: MomsRatesString.map((String rate) {
                  return DropdownMenuItem<String>(
                    value: rate,
                    child: Text(rate),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text("Total Cost"),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(TotalCost),
          ),
          SizedBox(
            height: 50,
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
      ),
    );
  }

  Widget DescriptionBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
            child: TextField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 30, // when user presses enter it will adapt to it
            ),
          ),
          SizedBox(
            height: 50,
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
      ),
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

  Widget DescriptionAppbar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/InovicePage');
        },
        child: Icon(Icons.keyboard_backspace),
      ),
      elevation: 5,
      title: Text("Add Description"),
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
    } else if (stateHolder == 3) {
      return DescriptionAppbar();
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
    } else if (stateHolder == 3) {
      return DescriptionBody();
    }
  }
}

dateFormatting(DateTime input) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(input);
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
