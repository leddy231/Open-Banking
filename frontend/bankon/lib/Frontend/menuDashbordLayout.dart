import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend/Auth.dart';


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
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeigh = size.height;
    screenWidth = size.width;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(children: <Widget>[
          dashbordMenu(context),
          menu(context),
        ]));
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
                    onTap: () {
                      Auth.signOut();
                    },
                    child: Text(
                      "loggout",
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
            } else if (details.delta.dx >5) {
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
          child: Material(
            animationDuration: duration,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            elevation: 8.0,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: InkWell(
                              child: Icon(
                                Icons.menu,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                setState(() {
                                  if (isCollapsed) {
                                    _controller.forward();
                                  } else {
                                    _controller.reverse();
                                  }
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 10,
                            child: Text("My Banks",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black54)),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: SizedBox(),
                          )

                        ]),
                    SizedBox(height: 15),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: bankDataLength ?? 1,
                      itemBuilder: (context, index) {
                        //Todo: add so that it can print data and redirrect from firestore
                        //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                        return Container();
                      },
                      //Todo: add so that it can print data and redirrect from firestore
                      //add same here as for itemBuilder
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
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
                    SizedBox(height: 10,),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/BankDataPage');
                          },
                          child: Center(
                            child: Text(
                              'Temporary transfer to Bank/Account Page',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
