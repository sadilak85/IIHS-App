import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/screens/main_page.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/utils/apifunctions/vehicleratings.dart';
import 'package:iihs/models/vehicleData.dart';

import 'dart:developer';

import '../models/constants/app_theme.dart';
import '../models/constants/app_theme.dart';
import '../models/constants/app_theme.dart';

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

  List<String> allMakeIdsListed, allMakeSlugsListed, allMakeNamesListed;
  List<String> modelIdsListed, modelSlugsListed, modelNamesListed;
  List<String> seriesIdsListed,
      seriesVariantTypeIdsListed,
      seriesSlugsListed,
      seriesiihsUrlsListed,
      seriesNamesListed;
  List<String> modelYearsListed;

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
      var _vehicleInfoData = await CrashRatings().crashRatings(
          selectedvehicle.modelyear,
          selectedvehicle.makeslug,
          selectedvehicle.seriesslug);

      vehicleInfoData = _vehicleInfoData;
    } catch (e) {
      print(e);
    }
    log(vehicleInfoData.toString());
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
            SizedBox(),
            SizedBox(),
          ],
          controller: _tabController,
        ),
      ),
      // floatingActionButton: [...]
    );

    //         return Padding(
    //           padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.1,
    //                 child: apptopBar(context),
    //               ),
    //               Expanded(
    //                 flex: 2,
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Center(
    //                     child: Container(
    //                       child: Image.network(
    //                         vehicleInfoData[2],
    //                         filterQuality: FilterQuality.low,
    //                         alignment: Alignment.center,
    //                         fit: BoxFit.cover,
    //                         loadingBuilder: (BuildContext context, Widget child,
    //                             ImageChunkEvent loadingProgress) {
    //                           if (loadingProgress == null) return child;
    //                           return Center(
    //                             child: CircularProgressIndicator(
    //                               value: loadingProgress.expectedTotalBytes !=
    //                                       null
    //                                   ? loadingProgress.cumulativeBytesLoaded /
    //                                       loadingProgress.expectedTotalBytes
    //                                   : null,
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 flex: 4,
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Container(
    //                     color: Theme.of(context).primaryColor,
    //                     child: Text(
    //                       vehicleInfoData.toString(),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}
