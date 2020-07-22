import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'package:flutter/material.dart';
import '../backend/Backend.dart';
import '../backend/Account.dart';
import 'package:url_launcher/url_launcher.dart';

//Contains list of all the bank you can select.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color backgroundColor = Colors.white;

class AccountDataPage extends StatefulWidget {
  final Account AccountData;

  AccountDataPage({Key key, @required this.AccountData}) : super(key:key);

  @override
  _AccountDataState createState() => _AccountDataState(AccountData);
}

class _AccountDataState extends State<AccountDataPage>
    with SingleTickerProviderStateMixin {
  Account AccountData;
  _AccountDataState(this.AccountData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            title: Text(AccountData.id),
            backgroundColor: Colors.lightGreen,
          ),
        ),

        backgroundColor: backgroundColor,
        body: Stack(children: <Widget>[Text("Money on account " + AccountData.balance + " " + AccountData.currency)]));
  }
}


