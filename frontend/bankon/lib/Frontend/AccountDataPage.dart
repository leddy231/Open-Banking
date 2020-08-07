import 'package:bankon/Frontend/InitiateTransaction.dart';
import 'package:decimal/decimal.dart';
import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BankDataPage.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';
import 'AccountDataPage.dart';

final Color backgroundColor = Colors.white;
int bankDataLength;

class AccountDataPage extends StatefulWidget {
  final Bank BankData;
  final Account AccountData;

  AccountDataPage(
      {Key key, @required this.BankData, @required this.AccountData})
      : super(key: key);

  //Todo: Add bank retrieve data and uppdate bankdata.length so list matches. Before the page is loaded

  @override
  _AccountDataState createState() => _AccountDataState(BankData, AccountData);
}

class _AccountDataState extends State<AccountDataPage>
    with TickerProviderStateMixin {
  Bank BankData;
  Account AccountData;

  _AccountDataState(this.BankData, this.AccountData);

  bool isCollapsed = true;
  double screenWidth, screenHeigh;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//test
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BankDataPage(BankData: BankData)));
              },
              child: Icon(Icons.keyboard_backspace),
            ),
            backgroundColor: Colors.lightGreen,
          ),
          body: accounts(context),
          drawer: GeneralDrawer(),
          backgroundColor: backgroundColor,
          floatingActionButton: _tabActionButton(context, BankData)),
    );
  }

  Widget accounts(context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              return true;
            },
            //Todo: Add check to see that it is loading the correct bank accounts
            child: StreamBuilder(
                stream: Auth.transactions(AccountData),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> transactionList = snapshot.data
                        .map((transactiondata) =>
                            transactionItem(transactiondata))
                        .toList();
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final item = transactionList[index];
                              return item.buildTransactionItem(context);
                            },
                            childCount: transactionList.length ?? 1,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Column(
                        children: <Widget>[CircularProgressIndicator()]);
                  }
                }),
          );
        },
      ),
    );
  }
}

//Todo: Create class for generating account finansial report graph.

abstract class ListTransactionItem {
  Widget buildTransactionItem(BuildContext context);
}

class transactionItem implements ListTransactionItem {
  final Transactions transactionData;

  transactionItem(this.transactionData);

  Transactions getTransactionData() {
    return transactionData;
  }

  @override
  Widget buildTransactionItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                transactionData.currency,
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.left,
              ),
              Spacer(
                flex: 2,
              ),
              Text(
                transactionData.amount,
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.start,
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                transactionData.date,
                style: TextStyle(color: Colors.black54, fontSize: 10),
                textAlign: TextAlign.left,
              ),
              Spacer(
                flex: 2,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: getAccountDropDownItems(),
                  onTap: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

List<DropdownMenuItem> getAccountDropDownItems() {
  List<DropdownMenuItem> items = new List();
  items.add(new DropdownMenuItem(
      value: "place holder action",
      child: new Text(
        "place holder action",
        style: TextStyle(color: Colors.white, fontFamily: 'semibold'),
      )));

  return items;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final sum;

  _SliverAppBarDelegate(this.sum);

  @override
  double get minExtent => 20;

  @override
  double get maxExtent => 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: Column(
        children: <Widget>[
          Text("Total balance:  " + sum.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.black, fontSize: 15)),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

getNewData() async {
  return await Auth.accounts().map((account) => accountItem).toList();
}

Widget _tabActionButton(BuildContext context, Bank BankData) {
  return Visibility(
    visible: true,
    child: FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InitTransaction(BankData: BankData)));
        },
        elevation: 8,
        tooltip: "Add Transaction",
        backgroundColor: Colors.lightGreen,
        child: Icon(
          Icons.add,
          size: 20.0,
        )),
  );
}
