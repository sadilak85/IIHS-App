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

          return DefaultTabController(
            length: _length + 1,
            child: Scaffold(
                backgroundColor: AppTheme.iihsbackground,
                endDrawer: AppDrawer(),
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
                        Row(
                          children: [
                            // IconButton(
                            //   icon: Icon(Icons.arrow_back_sharp),
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Container(
                                  child: Text(
                                    selectedvehicle.seriesname,
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
                              ),
                            ),
                          ],
                        ),
                        TabBar(
                          labelStyle: TextStyle(
                            fontSize: 16,
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
          if (arg.frontalRatingsModerateOverlapExists)
            if (["Good", "(Good)", "good", "(good)"].contains(
              arg.frontalRatingsModerateOverlap['overallRating'].toString(),
            ))
              ratingIndicator('Moderate overlap front', 'G'),

          if (["Acceptable", "(Acceptable)", "acceptable", "(acceptable)"]
              .contains(
            arg.frontalRatingsModerateOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Moderate overlap front', 'A'),
          if (["Marginal", "(Marginal)", "marginal", "(marginal)"].contains(
            arg.frontalRatingsModerateOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Moderate overlap front', 'M'),
          if (["Poor", "(Poor)", "poor", "(poor)"].contains(
            arg.frontalRatingsModerateOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Moderate overlap front', 'P'),
          //
          if (arg.frontalRatingsSmallOverlapExists)
            if (["Good", "(Good)", "good", "(good)"].contains(
              arg.frontalRatingsSmallOverlap['overallRating'].toString(),
            ))
              ratingIndicator('Small overlap front: driver-side', 'G'),
          if (["Acceptable", "(Acceptable)", "acceptable", "(acceptable)"]
              .contains(
            arg.frontalRatingsSmallOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: driver-side', 'A'),
          if (["Marginal", "(Marginal)", "marginal", "(marginal)"].contains(
            arg.frontalRatingsSmallOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: driver-side', 'M'),
          if (["Poor", "(Poor)", "poor", "(poor)"].contains(
            arg.frontalRatingsSmallOverlap['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: driver-side', 'P'),
          //
          if (arg.frontalRatingsSmallOverlapPassengerExists)
            if (["Good", "(Good)", "good", "(good)"].contains(
              arg.frontalRatingsSmallOverlapPassenger['overallRating']
                  .toString(),
            ))
              ratingIndicator('Small overlap front: passenger-side', 'G'),
          if (["Acceptable", "(Acceptable)", "acceptable", "(acceptable)"]
              .contains(
            arg.frontalRatingsSmallOverlapPassenger['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: passenger-side', 'A'),
          if (["Marginal", "(Marginal)", "marginal", "(marginal)"].contains(
            arg.frontalRatingsSmallOverlapPassenger['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: passenger-side', 'M'),
          if (["Poor", "(Poor)", "poor", "(poor)"].contains(
            arg.frontalRatingsSmallOverlapPassenger['overallRating'].toString(),
          ))
            ratingIndicator('Small overlap front: passenger-side', 'P'),
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
