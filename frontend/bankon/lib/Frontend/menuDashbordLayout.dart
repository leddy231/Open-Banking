import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend/Auth.dart';
import '../backend/Account.dart';
import '../backend/Backend.dart';
import 'package:bankon/Frontend/Drawer.dart';
import 'BankDataPage.dart';
import 'AccountDataPage.dart';

final Color backgroundColor = Colors.white;
int bankDataLength;

class MenuDashbord extends StatefulWidget {
  //Todo: Add bank retrieve data and uppdate bankdata.length so list matches. Before the page is loaded

  @override
  _MenuDashbordState createState() => _MenuDashbordState();
}

class _MenuDashbordState extends State<MenuDashbord>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeigh;
  final Duration duration = const Duration(milliseconds: 100);


  @override
  void initState() {
    super.initState();

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
            title: Text("My Banks"),
            backgroundColor: Colors.lightGreen,
          ),
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: Stack(children: <Widget>[
          menu(context),
        ]));
  }

  Widget menu(context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                  stream: Auth.userbanks(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> accountList = snapshot.data
                          .map((bankaccount) => bankItem(bankaccount))
                          .toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length ?? 1,
                        itemBuilder: (context, index) {
                          final item = accountList[index];

                          //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                          return InkWell(
                            onTap: () {

                             if(accountList[index].getBankData().bank.name == 'swedbank' && accountList[index].getBankData().consent == false){
                               Backend.getConsent(accountList[index].getBankData());
                             }
                              Backend.getAccounts(accountList[index].getBankData());
                             Backend.getAccountDetails(accountList[index].getBankData());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BankDataPage(
                                            BankData:
                                            item.getBankData().bank,
                                          )));

                            },
                            child: item.buildBankItem(context),
                          );
                        },

                        //add same here as for itemBuilder
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      );
                    } else {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[CircularProgressIndicator()],
                            ),
                            SizedBox(
                              height: 6,
                            )
                          ]);
                    }
                  }),
              Container(
                height: 40.0,
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  elevation: 2.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/bankSelect');
                    },
                    child: Center(
                      child: Text(
                        'Add Bank',
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
            ],
          ),
        ),
      ),
    );
  }
}

abstract class ListBankItem {
  Widget buildBankItem(BuildContext context);
}

class bankItem implements ListBankItem {
  final BankAccount bankData;

  bankItem(this.bankData);

  BankAccount getBankData() {
    return bankData;
  }

  @override
  Widget buildBankItem(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 2, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  bankData.bank.iconurl,
                  alignment: Alignment.center,
                  width: 55,
                  height: 55,
                ),
              ),
              SizedBox(width: 10),
              Text(
                bankData.bank.name.inCaps,
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.left,
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
}