import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';
import 'AccountDataPage.dart';

final Color backgroundColor = Colors.white;
int bankDataLength;

class BankData extends StatefulWidget {
  //Todo: Add bank retrieve data and uppdate bankdata.length so list matches. Before the page is loaded

  @override
  _BankDataState createState() => _BankDataState();
}

class _BankDataState extends State<BankData> with TickerProviderStateMixin {
  final List<Tab> BankTabs = <Tab>[
    Tab(
      text: "Konton",
    ),
    Tab(
      text: "Spara",
    ),
    Tab(
      text: "Lån",
    ),
    Tab(
      text: "Fakturor",
    )
  ];

  bool isCollapsed = true;
  double screenWidth, screenHeigh;
  final Duration duration = const Duration(milliseconds: 100);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    _tabController = TabController(vsync: this, length: BankTabs.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

//test

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeigh = size.height;
    screenWidth = size.width;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            backgroundColor: Colors.lightGreen,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: TabBar(
                        indicatorWeight: 2,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        controller: _tabController,
                        tabs: BankTabs,
                      ),
                    ),
                    SizedBox(width: 10),
                    //Todo: Fixa dropdown klart.
                    DropdownButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            menu(context),
          ],
        ));
  }

  Widget menu(context) {
    return Container(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          accounts(context),
          savings(context),
          loans(context),
          invoice(context)
        ],
      ),
    );
  }

  Widget accounts(context) {
    setState(() {});
    return Column(
      children: <Widget>[
        Container(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Temporay placeholder for financial graph data",
                  textAlign: TextAlign.center,
                ),
                // Expanded(...)
              ],
            ),
          ),
          height: 200,
          decoration: BoxDecoration(color: Colors.blueAccent),
        ),
        Container(
          child: StreamBuilder(
            stream: Auth.accounts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                List<dynamic> accountList = snapshot.data
                    .map((account) => accountItem(account))
                    .toList();
                int sum = 0;
                for (var i = 0; i < accountList.length; i++) {
                  sum += int.parse(accountList[i].getAccountData().balance);
                }
                return Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 2),
                          child: Text("Total balance:  " + sum.toString(),
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: accountList.length ?? 1,
                      itemBuilder: (context, index) {
                        final item = accountList[index];

                        //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountDataPage(
                                          AccountData: item.getAccountData(),
                                        )));
                          },
                          child: item.buildAccountItem(context),
                        );
                      },

                      //add same here as for itemBuilder
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ],
                );
              } else {
                return Container(
                  child: Text("loading"),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget savings(context) {
    setState(() {});
    return Container(
      child: Text("test2"),
    );
  }

  Widget loans(context) {
    setState(() {});
    return Container(
      child: Text("test3"),
    );
  }

  Widget invoice(context) {
    setState(() {});
    return Container(
      child: Text("test4"),
    );
  }
}

//Todo: Create class for generating account finansial report graph.

abstract class ListAccountItem {
  Widget buildAccountItem(BuildContext context);
}

class accountItem implements ListAccountItem {
  final Account accountData;

  accountItem(this.accountData);

  Account getAccountData() {
    return accountData;
  }

  @override
  Widget buildAccountItem(BuildContext context) {
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
                accountData.bank.name,
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.left,
              ),
              Spacer(
                flex: 2,
              ),
              Text(
                accountData.balance,
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
                accountData.numbers[1].number,
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
