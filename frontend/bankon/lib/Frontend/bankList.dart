import 'package:flutter/material.dart';
import '../backend/Backend.dart';

//Contains list of all the bank you can select.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color backgroundColor = Colors.white;

List<ListBankItem> outputData;

class bankList extends StatefulWidget {
  @override
  _bankListState createState() => _bankListState();
}

generateListBankItem() async {
  print("Started to load banks");
  final List banks = await Backend.getBanks();
  print("Banks loaded");
  print(banks);
  print(await Backend.getBankIcon(banks[0]));
  final List icons = new List<dynamic>();
  final List uri = new List<dynamic>();
  for (var i = 0; i < banks.length; i++) {
    print(await Backend.getBankIcon(banks[i]));
    uri.add(await Backend.getRedirectUrl(banks[i]));
  }
  print("icons and uri loaded");
  print(List<ListBankItem>.generate(banks.length,
          (index) => new bankItem(banks[index], uri[index], icons[index])));

}

class _bankListState extends State<bankList>
    with SingleTickerProviderStateMixin {
    static final banks = generateListBankItem();


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
                              child: Text("Select Bank",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black54)),
                            ),
                            Flexible(
                                fit: FlexFit.tight, flex: 1, child: SizedBox()),
                          ]),
                      SizedBox(height: 15),
                      FutureBuilder(
                        future: banks,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length ?? 1,
                              itemBuilder: (context, index) {
                                final item = snapshot.data[index];

                                //Todo: add so that it can print data and redirrect from firestore
                                //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                                return item.buildBankItem(context);
                              },
                              //Todo: add so that it can print data and redirrect from firestore
                              //add same here as for itemBuilder
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            );
                          } else {
                            return Container(
                              child: Text(
                                "loading"
                              ),
                            );
                          }
                        },
                      ),
                    ]),
              ),
            ),
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
  final String name;
  final String route;
  final Image picture;

  bankItem(this.name, this.route, this.picture);

  Widget buildBankItem(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          picture,
          SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(color: Colors.black54, fontSize: 24),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ));
  }
}
