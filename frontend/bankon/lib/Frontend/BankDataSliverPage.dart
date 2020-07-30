
import 'package:decimal/decimal.dart';
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
  TabController _tabController;
  int tabPage = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: BankTabs.length);
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

//test
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/menu');

                    },
                    child: Icon(
                        Icons.keyboard_backspace
                    ),
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
                              tabs: BankTabs,
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
            ];
          },
          body: menu(context)
        ),
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        floatingActionButton: _tabActionButton(tabPage, context)

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
            child: StreamBuilder(
                stream: Auth.accounts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> accountList = snapshot.data
                        .map((account) => accountItem(account))
                        .toList();
                    Decimal sum = Decimal.parse('0');
                    for (var i = 0; i < accountList.length; i++) {
                      sum += Decimal.parse(accountList[i].getAccountData().balance);
                    }
                    //Todo: Plocka ut dem och skapa en ny klass dit man skickar en ny sån grej.
                    return RefreshIndicator(
                      onRefresh: () {
                        return accountList = getNewData();
                      },
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(sum),
                          ),
                          SliverList(
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
                                                  AccountData:
                                                      item.getAccountData(),
                                                )));
                                  },
                                  child: item.buildAccountItem(context),
                                );
                              },
                              childCount: accountList.length ?? 1,
                            ),
                          )
                        ],
                      ),
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

Widget _tabActionButton(int tabPage,BuildContext context){
 return Visibility(
    visible: tabPage == 0,
    child: FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () {
        Navigator.of(context).pushNamed('/InitTransaction');
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