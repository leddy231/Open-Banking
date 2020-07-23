import 'package:bankon/backend/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'Drawer.dart';
import '../backend/Auth.dart';
import 'AccountDataPage.dart';

final Color backgroundColor = Colors.white;
int bankDataLength;

class BankSliverDataPage extends StatefulWidget {
  //Todo: Add bank retrieve data and uppdate bankdata.length so list matches. Before the page is loaded

  @override
  _BankDataState createState() => _BankDataState();
}

class _BankDataState extends State<BankSliverDataPage>
    with TickerProviderStateMixin {
  final List<Tab> BankTabs = <Tab>[
    Tab(
      text: "Konton2",
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
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(

                pinned: true,
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
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: AccountDataPageHeader(maxExtent: 60,minExtent: 60),
              )
            ];
          },
          body: menu(context),
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget menu(context) {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        accounts(context),
        savings(context),
        loans(context),
        invoice(context)
      ],
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
            child: CustomScrollView(
              slivers: <Widget>[

                StreamBuilder(
                    stream: Auth.accounts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> accountList = snapshot.data
                            .map((account) => accountItem(account))
                            .toList();

                        return SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                final item = accountList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountDataPage(
                                                  AccountData: item
                                                      .getAccountData(),
                                                )));
                                  },
                                  child: item.buildAccountItem(context),
                                );
                              },
                              childCount: accountList.length ?? 1,
                            ),
                          ),
                        );
                      } else
                        return SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.blueGrey,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[Text('hi $index')],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                );
                              },
                              childCount: 1,
                            ),
                          ),
                        );;
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget savings(context) {
    return Container(
      child: Text("test2"),
    );
  }

  Widget loans(context) {
    return Container(
      child: Text("test3"),
    );
  }

  Widget invoice(context) {
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


class AccountDataPageHeader implements SliverPersistentHeaderDelegate {
  AccountDataPageHeader({
    this.minExtent,
    @required this.maxExtent
  });

  final double minExtent;
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 40,),
            Row(
              children: <Widget>[
                Text(
                    "Test"
                )
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;


}