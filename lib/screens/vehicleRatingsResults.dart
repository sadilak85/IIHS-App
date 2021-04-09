import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/screens/main_page.dart';
import 'package:iihs/utils/apifunctions/vehicleratings.dart';
import 'package:iihs/models/vehicleData.dart';

import 'dart:developer';

class VehicleRatingsResults extends StatefulWidget {
  static const routeName = '/vehicleratings-results-screen';

  @override
  _VehicleRatingsResultsState createState() => _VehicleRatingsResultsState();
}

class _VehicleRatingsResultsState extends State<VehicleRatingsResults>
    with TickerProviderStateMixin {
  //
  ScrollController _scrollViewController;
  TabController _tabController;

  AnimationController animationController;
  Animation<double> animation;

  VehicleData selectedvehicle;

  List<String> vehicleInfoData = [];

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
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    setData();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> setData() async {
    animationController.forward();
  }

// Vehicle Ratings Data:
  Future<List<String>> getSelectedVehicleRatingData(
      VehicleData selectedvehicle) async {
    try {
      var _vehicleClassInfo = await CrashRatings().crashRatingsgetClass(
          selectedvehicle.modelyear,
          selectedvehicle.makeslug,
          selectedvehicle.seriesslug);

      vehicleInfoData = [_vehicleClassInfo];

      var _vehicleImagesData = await CrashRatings().crashRatingsImages(
          selectedvehicle.modelyear,
          selectedvehicle.makeslug,
          selectedvehicle.seriesslug);

      vehicleInfoData.add(_vehicleImagesData);

      var _vehicleFrontalRatingData = await CrashRatings().crashRatingsFrontal(
          selectedvehicle.modelyear,
          selectedvehicle.makeslug,
          selectedvehicle.seriesslug);

      vehicleInfoData = vehicleInfoData + _vehicleFrontalRatingData;

      log(vehicleInfoData.toString());
    } catch (e) {
      print(e);
    }

    return vehicleInfoData;
  }

  @override
  Widget build(BuildContext context) {
    VehicleData selectedvehicle = ModalRoute.of(context).settings.arguments;
    log(selectedvehicle.makename);
    log(selectedvehicle.modelname);
    log(selectedvehicle.seriesname);
    log(selectedvehicle.modelyear);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          //<-- headerSliverBuilder
          return <Widget>[
            SliverAppBar(
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

              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        MainPageScreen.routeName,
                      );
                    }),
              ],

              backgroundColor: AppTheme.iihsyellow,
              pinned: true, //<-- pinned to true
              floating: true, //<-- floating to true
              forceElevated:
                  innerBoxIsScrolled, //<-- forceElevated to innerBoxIsScrolled
              bottom: TabBar(
                tabs: <Tab>[
                  Tab(
                    text: "STATISTICS",
                  ),
                  Tab(
                    text: "HISTORY",
                  ),
                ],
                labelColor: AppTheme.darkText,
                indicatorColor: AppTheme.darkText,
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            frontalRating(selectedvehicle),
            SizedBox(),
          ],
          controller: _tabController,
        ),
      ),
      // floatingActionButton: [...]
    );
  }

  Widget frontalRating(arg) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<String>>(
        future: getSelectedVehicleRatingData(arg), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
            return Container(
              child: Text(
                vehicleInfoData.toString(),
              ),
            );
          }
        },
      ),
    );
  }
}
