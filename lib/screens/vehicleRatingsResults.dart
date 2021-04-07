import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/modelyears.dart';
import 'package:iihs/utils/apifunctions/vehicleimages.dart';
import 'package:iihs/utils/apifunctions/vehicleseries.dart';
import 'package:iihs/utils/apifunctions/ratings.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/models/vehicleData.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:developer';

import '../models/constants/app_theme.dart';

class VehicleRatingsResults extends StatefulWidget {
  const VehicleRatingsResults({Key key}) : super(key: key);
  static const routeName = '/vehicleratings-results-screen';
  @override
  _VehicleRatingsResultsState createState() => _VehicleRatingsResultsState();
}

class _VehicleRatingsResultsState extends State<VehicleRatingsResults>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  List<String> seriesIdsListed;
  List<String> seriesVariantTypeIdsListed;
  List<String> seriesSlugsListed = [];
  List<String> seriesiihsUrlsListed;
  List<String> seriesNamesListed;

  List<VehicleData> templateList = [];

  bool loading = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<List<VehicleData>> getSelectedVehicleData(
      VehicleData selectedvehicle) async {
    List<String> tempList = [];
    try {
      List<Map<dynamic, dynamic>> _vehicleseriesformakemodel;
      _vehicleseriesformakemodel = await VehicleSeries().getSeriesforMakeModel(
        selectedvehicle.makeslug,
        selectedvehicle.modelslug,
      );

      seriesIdsListed = mapData2List(_vehicleseriesformakemodel, 'id');
      seriesVariantTypeIdsListed =
          mapData2List(_vehicleseriesformakemodel, 'variantTypeId');
      seriesSlugsListed = mapData2List(_vehicleseriesformakemodel, 'slug');
      seriesiihsUrlsListed =
          mapData2List(_vehicleseriesformakemodel, 'iihsUrl');
      seriesNamesListed = mapData2List(_vehicleseriesformakemodel, 'name');

      for (int i = 0; i <= seriesSlugsListed.length - 1; i++) {
        var yearsData = await ModelYears().getModelYearsforMakeModelSeries(
          selectedvehicle.makeslug,
          seriesSlugsListed[i],
        );
        for (int j = 0; j <= yearsData.length - 1; j++) {
          String _imageURL = await VehicleImages().getMainImage(
              selectedvehicle.makename,
              seriesSlugsListed[i],
              yearsData[j]); // extra loop for years required

          templateList.add(
            VehicleData(
              makeid: selectedvehicle.makeid,
              makeslug: selectedvehicle.makeslug,
              makename: selectedvehicle.makename,
              modelid: selectedvehicle.modelid,
              modelslug: selectedvehicle.modelslug,
              modelname: selectedvehicle.modelname,
              modelyears: yearsData[j],
              seriesid: seriesIdsListed[i],
              seriesvariantTypeId: seriesVariantTypeIdsListed[i],
              seriesslug: seriesSlugsListed[i],
              seriesiihsUrl: seriesiihsUrlsListed[i],
              seriesname: seriesNamesListed[i],
              vehiclemainimage: _imageURL != null
                  ? _imageURL.toString()
                  : 'https://www.iihs.org/frontend/images/IIHS-HLDI-avatar-1200x1200.jpg',
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
    return templateList;
  }

  @override
  Widget build(BuildContext context) {
    VehicleData selectedvehicle = ModalRoute.of(context).settings.arguments;
    log(selectedvehicle.modelyears);
    log(selectedvehicle.makename);
    log(selectedvehicle.modelname);
    log(selectedvehicle.seriesname);

    final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.24),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));
    EasyLoading.dismiss();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.iihsyellow,
        title: Text("sdfsdf"),
      ),
      body: SizedBox(),
    );
  }

  void funcMakeonChanged(value) {
    // setState(() {
    //   enablemenu = false;
    // });
  }
}
