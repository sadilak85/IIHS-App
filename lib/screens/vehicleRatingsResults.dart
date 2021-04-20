import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/crashratings.dart';
import 'package:iihs/models/vehicleData.dart';
import 'package:iihs/utils/widgets/app_drawer.dart';

import 'dart:developer';

class VehicleRatingsResults extends StatefulWidget {
  static const routeName = '/vehicleratings-results-screen';

  @override
  _VehicleRatingsResultsState createState() => _VehicleRatingsResultsState();
}

class _VehicleRatingsResultsState extends State<VehicleRatingsResults>
    with TickerProviderStateMixin {
  //
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    setData();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> setData() async {
    animationController.forward();
  }

// Vehicle Ratings Data:
  Future<VehicleData> getSelectedVehicleRatingData(
      VehicleData selectedvehicle) async {
    try {
      selectedvehicle = await CrashRatings().crashRatingsData(selectedvehicle);
    } catch (e) {
      print(e);
    }
    return selectedvehicle;
  }

  @override
  Widget build(BuildContext context) {
    VehicleData selectedvehicle = ModalRoute.of(context).settings.arguments;
    log(selectedvehicle.makename);
    log(selectedvehicle.modelname);
    log(selectedvehicle.seriesname);
    log(selectedvehicle.modelyear);
    return FutureBuilder<VehicleData>(
      future: getSelectedVehicleRatingData(selectedvehicle),
      builder: (BuildContext context, AsyncSnapshot<VehicleData> snapshot) {
        if (snapshot.hasError) {
          EasyLoading.show(
            status: 'loading...',
          );
          return Center(
            child: Image.asset(
              'assets/images/logo-iihs.png',
              height: 60,
            ),
          );
        } else if (!snapshot.hasData) {
          EasyLoading.show(
            status: 'loading...',
          );
          return Center(
            child: Image.asset(
              'assets/images/logo-iihs.png',
              height: 60,
            ),
          );
        } else {
          EasyLoading.dismiss();
          int _length = 0;
          selectedvehicle.frontalRatingsModerateOverlapExists
              ? _length++
              : _length = _length;
          selectedvehicle.frontalRatingsSmallOverlapExists
              ? _length++
              : _length = _length;
          selectedvehicle.frontalRatingsSmallOverlapPassengerExists
              ? _length++
              : _length = _length;
          selectedvehicle.sideRatingsExists ? _length++ : _length = _length;
          selectedvehicle.rolloverRatingsExists ? _length++ : _length = _length;
          selectedvehicle.rearRatingsExists ? _length++ : _length = _length;
          selectedvehicle.headlightRatingsExists
              ? _length++
              : _length = _length;

          return DefaultTabController(
            length: _length + 1,
            child: Scaffold(
                backgroundColor: AppTheme.iihsbackground,
                //  endDrawer: AppDrawer(),
                appBar: AppBar(
                  backgroundColor: AppTheme.iihsyellow,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    'Vehicle Ratings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontWeight: FontWeight.w600,
                      fontSize: 20,
                      // letterSpacing: 0.27,
                      color: AppTheme.darkerText,
                    ),
                  ),
                  bottom: PreferredSize(
                    child: TabBar(
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkerText,
                      ),
                      isScrollable: true,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      unselectedLabelColor:
                          AppTheme.nearlyBlack.withOpacity(0.5),
                      indicatorColor: AppTheme.nearlyBlack,
                      tabs: [
                        Tab(
                          child: Text(
                            'Overview',
                          ),
                        ),
                        if (selectedvehicle.frontalRatingsModerateOverlapExists)
                          Tab(
                            child: Text('Moderate overlap front'),
                          ),
                        if (selectedvehicle.frontalRatingsSmallOverlapExists)
                          Tab(
                            child: Text('Small overlap front'),
                          ),
                        if (selectedvehicle
                            .frontalRatingsSmallOverlapPassengerExists)
                          Tab(
                            child: Text('Small overlap front: passenger side'),
                          ),
                        if (selectedvehicle.sideRatingsExists)
                          Tab(
                            child: Text('Side'),
                          ),
                        if (selectedvehicle.rolloverRatingsExists)
                          Tab(
                            child: Text('Roof strength'),
                          ),
                        if (selectedvehicle.rearRatingsExists)
                          Tab(
                            child: Text('Head restraints & seats'),
                          ),
                        if (selectedvehicle.headlightRatingsExists)
                          Tab(
                            child: Text('Headlights'),
                          ),
                      ],
                    ),
                    preferredSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.05),
                  ),
                  // actions: <Widget>[
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 16.0),
                  //     child: Icon(Icons.add_alert),
                  //   ),
                  // ],
                ),
                body: TabBarView(
                  children: <Widget>[
                    overallRatingView(selectedvehicle),
                    if (selectedvehicle.frontalRatingsModerateOverlapExists)
                      Container(
                        child: Text(selectedvehicle
                            .frontalRatingsModerateOverlap
                            .toString()),
                      ),
                    if (selectedvehicle.frontalRatingsSmallOverlapExists)
                      Container(
                        child: Text(selectedvehicle.frontalRatingsSmallOverlap
                            .toString()),
                      ),
                    if (selectedvehicle
                        .frontalRatingsSmallOverlapPassengerExists)
                      Container(
                        child: Text(selectedvehicle
                            .frontalRatingsSmallOverlapPassenger
                            .toString()),
                      ),
                    if (selectedvehicle.sideRatingsExists)
                      Container(
                        child: Text(selectedvehicle.sideRatings.toString()),
                      ),
                    if (selectedvehicle.rolloverRatingsExists)
                      Container(
                        child: Text(selectedvehicle.rolloverRatings.toString()),
                      ),
                    if (selectedvehicle.rearRatingsExists)
                      Container(
                        child: Text(selectedvehicle.rearRatings.toString()),
                      ),
                    if (selectedvehicle.headlightRatingsExists)
                      Container(
                        child:
                            Text(selectedvehicle.headlightRatings.toString()),
                      ),
                  ],
                )),
          );
        }
      },
    );
  }

  Widget overallRatingView(arg) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              arg.makename,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontWeight: FontWeight.w600,
                fontSize: 20,
                // letterSpacing: 0.27,
                color: AppTheme.darkerText,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              arg.seriesname,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontWeight: FontWeight.w600,
                fontSize: 18,
                // letterSpacing: 0.27,
                color: AppTheme.darkerText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                arg.vehiclemainimage ?? 'no image',
                //textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 8),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                arg.vehicleclass,
                //textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
          //
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Crashworthiness",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
          //
          // Small overlap front: driver-side Ratings:
          if (arg.frontalRatingsSmallOverlapExists)
            if (arg.frontalRatingsSmallOverlap['overallRating']
                .toString()
                .contains("Good"))
              ratingIndicator('Small overlap front: driver-side', 'G'),
          if (arg.frontalRatingsSmallOverlap['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Small overlap front: driver-side', 'A'),
          if (arg.frontalRatingsSmallOverlap['overallRating']
              .toString()
              .contains("Marginal"))
            ratingIndicator('Small overlap front: driver-side', 'M'),
          if (arg.frontalRatingsSmallOverlap['overallRating']
              .toString()
              .contains("Poor"))
            ratingIndicator('Small overlap front: driver-side', 'P'),
          // Small overlap front: passenger-side Ratings:
          if (arg.frontalRatingsSmallOverlapPassengerExists)
            if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
                .toString()
                .contains("Good"))
              ratingIndicator('Small overlap front: passenger-side', 'G'),
          if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Small overlap front: passenger-side', 'A'),
          if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
              .toString()
              .contains("Marginal"))
            ratingIndicator('Small overlap front: passenger-side', 'M'),
          if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
              .toString()
              .contains("Poor"))
            ratingIndicator('Small overlap front: passenger-side', 'P'),
          // Moderate overlap front Ratings:
          if (arg.frontalRatingsModerateOverlapExists)
            if (arg.frontalRatingsModerateOverlap['overallRating']
                .toString()
                .contains("Good"))
              ratingIndicator('Moderate overlap front', 'G'),
          if (arg.frontalRatingsModerateOverlap['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Moderate overlap front', 'A'),
          if (arg.frontalRatingsModerateOverlap['overallRating']
              .toString()
              .contains("Marginal"))
            ratingIndicator('Moderate overlap front', 'M'),
          if (arg.frontalRatingsModerateOverlap['overallRating']
              .toString()
              .contains("Poor"))
            ratingIndicator('Moderate overlap front', 'P'),
          // Side Ratings:
          if (arg.sideRatingsExists)
            if (arg.sideRatings['overallRating'].toString().contains("Good"))
              ratingIndicator('Side', 'G'),
          if (arg.sideRatings['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Side', 'A'),
          if (arg.sideRatings['overallRating'].toString().contains("Marginal"))
            ratingIndicator('Side', 'M'),
          if (arg.sideRatings['overallRating'].toString().contains("Poor"))
            ratingIndicator('Side', 'P'),
          // Roof Strength Ratings:
          if (arg.rolloverRatingsExists)
            if (arg.rolloverRatings['overallRating']
                .toString()
                .contains("Good"))
              ratingIndicator('Roof strength', 'G'),
          if (arg.rolloverRatings['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Roof strength', 'A'),
          if (arg.rolloverRatings['overallRating']
              .toString()
              .contains("Marginal"))
            ratingIndicator('Roof strength', 'M'),
          if (arg.rolloverRatings['overallRating'].toString().contains("Poor"))
            ratingIndicator('Roof strength', 'P'),
          // Head restraints & seats Ratings
          if (arg.rearRatingsExists)
            if (arg.rearRatings['overallRating'].toString().contains("Good"))
              ratingIndicator('Head restraints & seats', 'G'),
          if (arg.rearRatings['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Head restraints & seats', 'A'),
          if (arg.rearRatings['overallRating'].toString().contains("Marginal"))
            ratingIndicator('Head restraints & seats', 'M'),
          if (arg.rearRatings['overallRating'].toString().contains("Poor"))
            ratingIndicator('Head restraints & seats', 'P'),
          // Headlights Ratings:
          if (arg.headlightRatingsExists)
            if (arg.headlightRatings['overallRating']
                .toString()
                .contains("Good"))
              ratingIndicator('Headlights', 'G'),
          if (arg.headlightRatings['overallRating']
              .toString()
              .contains("Acceptable"))
            ratingIndicator('Headlights', 'A'),
          if (arg.headlightRatings['overallRating']
              .toString()
              .contains("Marginal"))
            ratingIndicator('Headlights', 'M'),
          if (arg.headlightRatings['overallRating'].toString().contains("Poor"))
            ratingIndicator('Headlights', 'P'),
          //
          //
        ],
      ),
    );
  }

  Widget ratingIndicator(_text, _ind) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 50, right: 50),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                _text,
                //textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            color: _ind == 'G'
                ? AppTheme.iihsratingsgreen
                : _ind == 'A'
                    ? AppTheme.iihsratingsyellow
                    : _ind == 'M'
                        ? AppTheme.iihsratingsorange
                        : _ind == 'P'
                            ? AppTheme.iihsratingsred
                            : AppTheme.iihsratingsgreen,
            child: Center(
              child: Text(
                _ind,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
