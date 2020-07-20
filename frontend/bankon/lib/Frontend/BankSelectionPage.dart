import 'package:bankon/Frontend/Drawer.dart';
import 'package:flutter/material.dart';
import '../backend/Backend.dart';
import '../backend/Account.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final List<Bank> banks = await Backend.getBanks();
  return List<ListBankItem>.generate(
      banks.length, (index) => BankItem(banks[index]));
}

class _bankListState extends State<bankList>
    with SingleTickerProviderStateMixin {
  final banks = generateListBankItem();

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
        drawer: GeneralDrawer(),
        backgroundColor: backgroundColor,
        body: Stack(children: <Widget>[
          menu(context),
        ]));
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

                                //Here is all the banks that we added with bank info. Picture and associated route to their own pages
                                return item.buildBankItem(context);
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

class BankItem implements ListBankItem {
  final Bank bankData;

  BankItem(this.bankData);

  @override
  Widget buildBankItem(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        launch(bankData.redirecturl);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              bankData.iconurl,
              alignment: Alignment.center,
              width: 55,
              height: 55,
            ),
          ),
          SizedBox(width: 10),
          Text(
            bankData.name,
            style: TextStyle(color: Colors.black54, fontSize: 24),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ));
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
}
