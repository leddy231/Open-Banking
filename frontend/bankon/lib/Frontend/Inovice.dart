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

class InovicePage extends StatefulWidget {
  //Todo: Add bank retrieve data and uppdate bankdata.length so list matches. Before the page is loaded

  @override
  _InoviceState createState() => _InoviceState();
}

class _InoviceState extends State<InovicePage> with TickerProviderStateMixin {
  final List<Tab> InoviceTabs = <Tab>[
    Tab(
      text: "Incoming",
    ),
    Tab(
      text: "Outgoing",
    ),
  ];

  TabController _tabController;
  int tabPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: InoviceTabs.length);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {
      tabPage = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                    child: Icon(Icons.keyboard_backspace),
                  ),
                  backgroundColor: Colors.lightGreen,
                  pinned: true,
                  floating: false,
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
                              tabs: InoviceTabs,
                            ),
                          ),

                          SizedBox(width: 10),
                          //Todo: Fixa dropdown klart.
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: InovicePersistentHeaderDeleagate(),
              ),
            ];
          },
          body: menu(context)),
      backgroundColor: backgroundColor,
      drawer: GeneralDrawer(),
      floatingActionButton: _inoviceInitButton(context),
    );
  }

  Widget menu(context) {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        incoming(context),
        outgoing(context),
      ],
    );
  }

  Widget incoming(context) {
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
            child: CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index % 3 == 0) {
                      return Container(color: Colors.red, height: 150.0);
                    } else if (index % 5 == 0) {
                      return Container(color: Colors.green, height: 150.0);
                    } else {
                      return Container(color: Colors.blue, height: 150.0);
                    }
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget outgoing(context) {
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
            child: CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index % 3 == 0) {
                      return Container(color: Colors.red, height: 20.0);
                    } else if (index % 5 == 0) {
                      return Container(color: Colors.green, height: 20.0);
                    } else {
                      return Container(color: Colors.blue, height: 20.0);
                    }
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class InovicePersistentHeaderDeleagate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      height: 70.0,
      child: Material(
        color: backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Text("PLACEHOLDER TEXT")],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(InovicePersistentHeaderDeleagate oldDelegate) {
    return false;
  }
}

Widget _inoviceInitButton(
  BuildContext context,
) {
  return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: () {
        Navigator.of(context).pushNamed('/InitInovice');
      },
      elevation: 8,
      tooltip: "Add Inovice",
      backgroundColor: Colors.lightGreen,
      child: Icon(
        Icons.add,
        size: 20.0,
      ));
}
