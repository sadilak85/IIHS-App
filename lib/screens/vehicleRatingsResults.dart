import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/crashRatings.dart';
import 'package:iihs/models/vehicleData.dart';
import 'package:iihs/utils/widgets/ratingsOverviewTab.dart';

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
          selectedvehicle.frontCrashPreventionRatingsExists
              ? _length++
              : _length = _length;
          selectedvehicle.pedestrianAvoidanceRatingsExists
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
                        if (selectedvehicle.frontCrashPreventionRatingsExists)
                          Tab(
                            child: Text(
                                'Front crash prevention: vehicle-to-vehicle'),
                          ),
                        if (selectedvehicle.pedestrianAvoidanceRatingsExists)
                          Tab(
                            child: Text(
                                'Front crash prevention: vehicle-to-pedestrian'),
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
                    ratingsOverviewTab(selectedvehicle),
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
                    if (selectedvehicle.frontCrashPreventionRatingsExists)
                      Container(
                        child: Text(selectedvehicle.frontCrashPreventionRatings
                            .toString()),
                      ),
                    if (selectedvehicle.pedestrianAvoidanceRatingsExists)
                      Container(
                        child: Text(selectedvehicle.pedestrianAvoidanceRatings
                            .toString()),
                      ),
                  ],
                )),
          );
        }
      },
    );
  }
}
