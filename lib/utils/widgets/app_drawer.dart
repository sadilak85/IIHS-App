import 'package:flutter/material.dart';
import 'package:iihs/screens/drawer_contact_screen.dart';
//import '../utils/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            actions: <Widget>[
              Container(),
            ],
            title: Text('Explore'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('IIHS Vehicle Rating'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Find my Car Model'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Read more '),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('About Crash Ratings'),
            onTap: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
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
