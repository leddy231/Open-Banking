import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 28,21 min
 */
final Color backgroundColor = Color(0xFF4A4A58);

class MenuDashbord extends StatefulWidget {
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
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
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
          menu(context),
          dashbord(context),
        ]));
  }

  Widget menu(context) {
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
                  Text(
                    "Dashbord",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Messages",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Utility",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Funds Transfer",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Branches",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget dashbord(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8.0,
          color: backgroundColor,
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
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
                      Text("My Banks",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(Icons.settings, color: Colors.white),
                    ]),
                SizedBox(height: 15),
                Container(
                  height: 200,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.8),
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.redAccent,
                        width: 100,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.blueAccent,
                        width: 100,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.greenAccent,
                        width: 100,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
