import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';

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
                Container(
                  child: Row(
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
                  ),
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
    return TabBarView(
      controller: _tabController,
      //Todo: For children add methods that run each specific page.
      children: <Widget>[
        accounts(context),
        savings(context),
        loans(context),
        invoice(context)
      ],
    );
  }

  Widget accounts(context) {
    setState(() {

    });
    return Container(
      child: StreamBuilder(
        stream: Auth.accounts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
         List<dynamic> accountList =  snapshot.data.map((account) => accountItem(account)).toList();
            return ListView.separated(
              shrinkWrap: true,
              itemCount: accountList.length ?? 1,
              itemBuilder: (context, index) {
                final item = accountList[index];

                //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                return item.buildAccountItem(context);
              },

              //add same here as for itemBuilder
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          } else {
            return Container(
              child: Text("loading"),
            );
          }
        },
      ),
    );
  }

  Widget savings(context) {
    setState(() {

    });
    return Container(
      child: Text("test2"),
    );
  }

  Widget loans(context) {
    setState(() {

    });
    return Container(
      child: Text("test3"),
    );
  }

  Widget invoice(context) {
    setState(() {

    });
    return Container(
      child: Text("test4"),
    );
  }
}

abstract class ListAccountItem {
  Widget buildAccountItem(BuildContext context);
}

class accountItem implements ListAccountItem {
  final Account accountData;

  accountItem(this.accountData);

  @override
  Widget buildAccountItem(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
          ),
          SizedBox(width: 10),
          Text(
            accountData.id,
            style: TextStyle(color: Colors.black54, fontSize: 10),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
