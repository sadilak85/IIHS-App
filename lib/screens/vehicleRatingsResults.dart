import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehicleratings.dart';
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
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitChasingDots(
              color: AppTheme.nearlyBlack,
              size: 100.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: SpinKitChasingDots(
              color: AppTheme.nearlyBlack,
              size: 100.0,
            ),
          );
        } else {
          return DefaultTabController(
            length: 6,
            child: Scaffold(
                backgroundColor: AppTheme.iihsbackground,
                endDrawer: AppDrawer(),
                appBar: AppBar(
                  backgroundColor: AppTheme.iihsyellow,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Center(
                    child: Text(
                      'Vehicle Ratings',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontWeight: FontWeight.w600,
                        fontSize: 20,
                        // letterSpacing: 0.27,
                        color: AppTheme.darkerText,
                      ),
                    ),
                  ),

                  bottom: PreferredSize(
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor:
                            AppTheme.nearlyBlack.withOpacity(0.5),
                        indicatorColor: AppTheme.nearlyBlack,
                        tabs: [
                          Tab(
                            child: Text(
                              'Overall',
                              // style: TextStyle(
                              //   fontSize: 14,
                              //   color: AppTheme.darkerText,
                              // ),
                            ),
                          ),
                          Tab(
                            child: Text('Investment'),
                          ),
                          Tab(
                            child: Text(selectedvehicle
                                    .frontalRatingsModerateOverlapExists
                                ? selectedvehicle
                                    .frontalRatingsModerateOverlapExists
                                    .toString()
                                : 'keke'),
                          ),
                          Tab(
                            child: Text('Current Balance'),
                          ),
                          Tab(
                            child: Text('Tab 5'),
                          ),
                          Tab(
                            child: Text('Tab 6'),
                          )
                        ]),
                    preferredSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.1),
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
                    frontalRating(selectedvehicle),
                    Container(
                      child: Center(
                        child: Text('Tab 2'),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text('Tab 3'),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text('Tab 4'),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text('Tab 5'),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text('Tab 6'),
                      ),
                    ),
                  ],
                )),
          );
        }
      },
    );
  }

  Widget frontalRating(arg) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<VehicleData>(
        future: getSelectedVehicleRatingData(arg), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<VehicleData> snapshot) {
          if (snapshot.hasError) {
            EasyLoading.show(
              status: 'loading...',
            );
            return Container(
              child: null,
              // DO SOMETHING !!!!!!!!!!!!!!!!!!!  RETURN BACK ODER SO
            );
          } else if (!snapshot.hasData) {
            EasyLoading.show(
              status: 'loading...',
            );
            return Container(
              child: null,
            );
          } else {
            EasyLoading.dismiss();
            return Column(
              children: [
                Container(
                  child: Text(
                    arg.vehicleclass,
                  ),
                ),
                Container(
                  child: Text(
                    arg.frontalRatingsModerateOverlap['overallRating']
                        .toString(),
                  ),
                ),
                Container(
                  child: Text(
                    arg.frontalRatingsSmallOverlap['overallRating'].toString(),
                  ),
                ),
                Container(
                  child: Text(
                    arg.frontalRatingsSmallOverlapPassenger['overallRating']
                        .toString(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
