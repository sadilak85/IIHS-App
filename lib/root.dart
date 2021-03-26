import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/helpers/custom_route.dart';
import 'package:iihs/screens/vehicleratings_selection.dart';
import 'package:iihs/screens/vehicleratings_overview.dart';
import 'package:iihs/screens/drawer_contact_screen.dart';
import 'package:iihs/screens/main_page.dart';

class MyAppRoot extends StatefulWidget {
  @override
  _MyAppRootState createState() => _MyAppRootState();
}

class _MyAppRootState extends State<MyAppRoot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIHS Main',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.grey[400],
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        bottomAppBarColor: Colors.grey,
        canvasColor: Colors.white,
        //canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.iihsyellow,
              ),
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
      ),
      home: MainPageScreen(),
      routes: {
        ContactScreen.routeName: (ctx) => ContactScreen(),
        VehicleRatingsSelection.routeName: (ctx) => VehicleRatingsSelection(),
        VehicleRatingsOverview.routeName: (ctx) => VehicleRatingsOverview(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => MainPageScreen(),
        );
      },
    );
  }
}
