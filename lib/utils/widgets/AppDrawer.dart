import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/screens/drawer_contact_screen.dart';
//import '../utils/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: AppTheme.iihsyellow,
            elevation: 10,
            actions: <Widget>[
              Container(),
            ],
            title: Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/images/logo-iihs.png',
                height: 40,
                fit: BoxFit.fitHeight,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_outlined),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.poll_outlined),
            title: Text('IIHS Vehicle Rating'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_car_outlined),
            title: Text('Search by Make/Model'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_car_outlined),
            title: Text('Search by Type/Class'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('About Crash Ratings'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.perm_phone_msg_outlined),
            title: Text('Contact IIHS'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
