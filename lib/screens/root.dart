import 'package:flutter/material.dart';
import 'package:iihs/helpers/custom_route.dart';
import 'package:iihs/screens/tabs_screen.dart';
import 'package:iihs/screens/categories_screen.dart';
import 'package:iihs/screens/loading_screen.dart';

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
        accentColor: Colors.yellow[700],
        bottomAppBarColor: Color.fromRGBO(52, 52, 52, 1),
        canvasColor: Color.fromRGBO(205, 204, 51, 1),
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
                color: Colors.yellow,
              ),
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
      ),
      home: TabsScreen(),
      routes: {
        LoadingScreen.routeName: (ctx) => LoadingScreen(),
        TabsScreen.routeName: (ctx) => TabsScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
