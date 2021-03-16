import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/models/ratingsmodel.dart';
import 'dart:developer';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading-screen';
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getRatingsData();
  }

  void getRatingsData() async {
    var yearsData = await RatingsModel().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await RatingsModel().testRatings();

    log('data: $data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
