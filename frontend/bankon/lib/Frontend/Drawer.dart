import 'package:flutter/material.dart';
import '../backend/Auth.dart';

class GeneralDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Text(
              'Test Testssons        Bankon Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/menu');
            },
            child: ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('My banks'),
            ),
          ),InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/InovicePage');
            },
            child: ListTile(
              leading: Icon(Icons.find_in_page),
              title: Text('Invoices'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/Profile");
            },
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/settings");
            },
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          InkWell(
            onTap: () {
              Auth.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/startPage', (Route<dynamic> route) => false);
              Auth.signOut();
            },
            child: ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
            ),
          )
        ],
      ),
    );
  }
}
