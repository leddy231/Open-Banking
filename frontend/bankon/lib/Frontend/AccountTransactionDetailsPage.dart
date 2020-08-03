import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import 'package:bankon/Frontend/Drawer.dart';

import '../backend/Account.dart';

final Color backgroundColor = Colors.white;

class AccountTransactionDetailsPage extends StatefulWidget {
  final Account AccountData;

  AccountTransactionDetailsPage({Key key, @required this.AccountData})
      : super(key: key);

  @override
  _AccountDataState createState() => _AccountDataState(AccountData);
}

class _AccountDataState extends State<AccountTransactionDetailsPage>
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
