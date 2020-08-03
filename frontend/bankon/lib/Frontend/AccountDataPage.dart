import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'package:flutter/material.dart';
import '../backend/Backend.dart';
import '../backend/Account.dart';
import 'BankDataPage.dart';
import 'package:url_launcher/url_launcher.dart';

//Contains list of all the bank you can select.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color backgroundColor = Colors.white;

class AccountDataPage extends StatefulWidget {
  final Account AccountData;

  AccountDataPage({Key key, @required this.AccountData}) : super(key: key);

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
            leading: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BankDataPage(
                              BankData:
                                AccountData.bank
                            )));

              },
              child: Icon(
                  Icons.keyboard_backspace
              ),
            ),
            title: Text(AccountData.numbers[1].number),
            backgroundColor: Colors.lightGreen,
          ),
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: Stack(children: <Widget>[
          Text("Money on account " +
              AccountData.balance +
              " " +
              AccountData.currency)
        ]));
  }
}
