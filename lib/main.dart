import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/helpers/custom_route.dart';
import 'package:iihs/screens/vehicleSelectMakeModel.dart';
import 'package:iihs/screens/vehicleSelectMake.dart';
import 'package:iihs/screens/vehiclesOverview.dart';
import 'package:iihs/screens/vehicleRatingsResults.dart';
import 'package:iihs/screens/drawer_contact_screen.dart';
import 'package:iihs/screens/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'IIHS Main',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
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
        VehicleSelectMakeModel.routeName: (ctx) => VehicleSelectMakeModel(),
        VehicleSelectMake.routeName: (ctx) => VehicleSelectMake(),
        VehicleRatingsOverview.routeName: (ctx) => VehicleRatingsOverview(),
        VehicleRatingsResults.routeName: (ctx) => VehicleRatingsResults(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => MainPageScreen(),
        );
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/ratings':
            return PageTransition(
              child: VehicleRatingsResults(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              settings: settings,
            );
            break;

          case '/selectmakemodel':
            return PageTransition(
              child: VehicleSelectMakeModel(),
              curve: Curves.bounceIn,
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              settings: settings,
            );
            break;

          case '/selectmake':
            return PageTransition(
              child: VehicleSelectMake(),
              curve: Curves.bounceIn,
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              settings: settings,
            );
            break;

          default:
            return null;
        }
      },
    );
  }
}
