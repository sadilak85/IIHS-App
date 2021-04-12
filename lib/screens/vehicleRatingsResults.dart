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

          log(selectedvehicle.frontalRatingsModerateOverlapExists.toString());
          log(_length.toString());
          return DefaultTabController(
            length: _length + 1,
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
                  title: Text(
                    selectedvehicle.makename,
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
                    child: Column(
                      children: [
                        Text(
                          selectedvehicle.seriesname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontWeight: FontWeight.w600,
                            fontSize: 20,
                            // letterSpacing: 0.27,
                            color: AppTheme.darkerText,
                          ),
                        ),
                        TabBar(
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: AppTheme.darkerText,
                          ),
                          isScrollable: true,
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16,
                          ),
                          unselectedLabelColor:
                              AppTheme.nearlyBlack.withOpacity(0.5),
                          indicatorColor: AppTheme.nearlyBlack,
                          tabs: [
                            Tab(
                              child: Text(
                                'Overall',
                              ),
                            ),
                            if (selectedvehicle
                                .frontalRatingsModerateOverlapExists)
                              Tab(
                                child: Text('Front Moderate Overlap'),
                              ),
                            if (selectedvehicle
                                .frontalRatingsSmallOverlapExists)
                              Tab(
                                child: Text('SmallOverlap'),
                              ),
                            if (selectedvehicle
                                .frontalRatingsSmallOverlapPassengerExists)
                              Tab(
                                child: Text('SmallOverlap Passenger'),
                              ),
                          ],
                        ),
                      ],
                    ),
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
      body: Column(
        children: [
          Container(
            child: Text(
              arg.vehicleclass,
            ),
          ),
          Container(
            child: Text(
              arg.frontalRatingsModerateOverlap['overallRating'].toString(),
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
      ),
    );
  }
}
