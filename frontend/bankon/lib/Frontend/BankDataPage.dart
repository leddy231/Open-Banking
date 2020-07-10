import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(
          title: Text("/BankNAmeData"),
          actions: <Widget>[Text("/BankNameData",textAlign: TextAlign.left,), Icon(Icons.iso)],
          bottom: TabBar(
            controller: _tabController,
            tabs: BankTabs,
          ),
        ),
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            dashbordMenu(context),
            menu(context),
          ],
        ));
  }

  Widget dashbordMenu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/menu');
                    },
                    child: Text(
                      "My Banks",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Messages",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Utility",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Funds Transfer",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Branches",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget menu(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx < -5) {
              isCollapsed = true;
            } else if (details.delta.dx > 5) {
              isCollapsed = false;
            }
            setState(() {
              if (isCollapsed) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            });
          },
          child: TabBarView(
            controller: _tabController,
            children: BankTabs.map((Tab tab) {
              final String label = tab.text;
              return Center(
                child: Text(
                  'This is the $label tab',
                  style: const TextStyle(fontSize: 36),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
