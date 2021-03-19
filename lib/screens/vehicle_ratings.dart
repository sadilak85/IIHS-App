import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/helpers/app_theme.dart';
import 'package:iihs/models/modelyears.dart';
import 'package:iihs/models/ratings.dart';
import 'package:iihs/screens/main_page.dart';
import 'package:iihs/widgets/app_drawer.dart';

import 'dart:developer';

class VehicleRatings extends StatefulWidget {
  static const routeName = '/vehicleratings-screen';
  @override
  State<StatefulWidget> createState() {
    return _VehicleRatingsState();
  }
}

class _VehicleRatingsState extends State<VehicleRatings> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getRatingsData();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void getRatingsData() async {
    var yearsData = await ModelYears().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await CrashRatings()
        .crashRatings('2021', 'bmw', '2-series-2-door-coupe');

    log(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.iihsbackground,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Vehicle Ratings"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              MainPageScreen.routeName,
            );
          },
          child: Icon(Icons.home_filled // add custom icons also
              ),
        ),
        // actions: <Widget>[
        //   Padding(
        //       padding: EdgeInsets.only(right: 20.0),
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Icon(
        //           Icons.search,
        //           size: 26.0,
        //         ),
        //       )),
        //   Padding(
        //       padding: EdgeInsets.only(right: 20.0),
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Icon(Icons.more_vert),
        //       )),
        // ],
      ),
      body: Center(
        child: SpinKitDoubleBounce(
          color: AppTheme.grey,
          size: 100.0,
        ),
      ),
    );
  }
}

//https://www.iihs.org/media/86f4d476-d13a-42da-89f7-3ff733dd2ada/ju_oBg/HeroImages/rating-hero.jpg
