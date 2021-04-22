import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehiclemodelyears.dart';
import 'package:iihs/utils/apifunctions/vehicleimages.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/models/vehicleData.dart';
import 'package:iihs/screens/vehicleRatingsResults.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:developer';

class VehicleRatingsOverview extends StatefulWidget {
  const VehicleRatingsOverview({Key key}) : super(key: key);
  static const routeName = '/vehicleratings-overview-screen';
  @override
  _VehicleRatingsOverviewState createState() => _VehicleRatingsOverviewState();
}

class _VehicleRatingsOverviewState extends State<VehicleRatingsOverview>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  List<String> seriesIdsListed;
  List<String> seriesVariantTypeIdsListed;
  List<String> seriesSlugsListed = [];
  List<String> seriesiihsUrlsListed;
  List<String> seriesNamesListed;
  List<String> modelidsListed;
  List<String> modelSlugsListed;
  List<String> modelNamesListed;
  List<VehicleData> templateList = [];

  bool initialize = true;

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
    try {
      var yearsData = await ModelYears().getModelYearsforMakeModelSeries(
        selectedvehicle.makeslug,
        selectedvehicle.seriesslug,
      );
      for (int j = 0; j <= yearsData.length - 1; j++) {
        String _imageURL = await VehicleImages().getMainImage(
            selectedvehicle.makename, selectedvehicle.seriesslug, yearsData[j]);

        templateList.add(
          VehicleData(
            makeid: selectedvehicle.makeid,
            makeslug: selectedvehicle.makeslug,
            makename: selectedvehicle.makename,
            modelid: selectedvehicle.modelid,
            modelslug: selectedvehicle.modelslug,
            modelname: selectedvehicle.modelname,
            modelyear: yearsData[j],
            seriesid: selectedvehicle.seriesid,
            seriesvariantTypeId: selectedvehicle.seriesvariantTypeId,
            seriesslug: selectedvehicle.seriesslug,
            seriesiihsUrl: selectedvehicle.seriesiihsUrl,
            seriesname: selectedvehicle.seriesname,
            vehiclemainimage: _imageURL,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    return templateList;
  }

  @override
  Widget build(BuildContext context) {
    VehicleData selectedvehicle = ModalRoute.of(context).settings.arguments;

    log(selectedvehicle.makename);
    log(selectedvehicle.modelname);
    log(selectedvehicle.seriesname);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<VehicleData>>(
        future:
            getSelectedVehicleData(selectedvehicle), // a Future<String> or null
        builder:
            (BuildContext context, AsyncSnapshot<List<VehicleData>> snapshot) {
          if (snapshot.hasError) {
            EasyLoading.show(
              status: 'loading...',
            );
            return Container(
              child: null,
              // DO SOMETHING !!!!!!!!!!!!!!!!!!!  RETURN BACK ODER SO
            );
          } else if (!snapshot.hasData) {
            return mainview(initialize);
          } else {
            initialize = !initialize;
            return mainview(initialize);
          }
        },
      ),
    );
  }

  Widget mainview(bool initialize) {
    final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.24),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));

    if (initialize) {
      EasyLoading.show(
        status: 'loading...',
      );
    } else {
      EasyLoading.dismiss();
    }
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                selectiontopimage,
                alignment: Alignment.center,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          top: initialize
              ? MediaQuery.of(context).size.height * 0.38
              : MediaQuery.of(context).size.height * 0.15,
          bottom: 0,
          left: 0,
          right: 0,
          child: initialize
              ? Container(
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: SizedBox(),
                )
              : SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.nearlyWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: GridView(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: List<Widget>.generate(
                        templateList.length,
                        (int index) {
                          final int count = templateList.length;
                          final Animation<double> animation2 =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController.forward();
                          return TemplateListView(
                            animation: animation2,
                            animationController: animationController,
                            animationvaluechanger: index % 2 == 0 ? 100 : -100,
                            listData: templateList.reversed.toList()[index],
                          );
                        },
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: 2.5,
                      ),
                    ),
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SizedBox(
            width: AppBar().preferredSize.height,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
                child: Icon(
                  Icons.arrow_back,
                  color: AppTheme.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TemplateListView extends StatelessWidget {
  const TemplateListView(
      {Key key,
      this.listData,
      this.animationController,
      this.animation,
      this.animationvaluechanger})
      : super(key: key);

  final VehicleData listData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final int animationvaluechanger;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                animationvaluechanger * (1.0 - animation.value), 0.0, 0.0),
            child: Stack(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  elevation: 5,
                  color: AppTheme.iihsbackground,
                  child: Row(
                    children: [
                      Expanded(
                        flex: (MediaQuery.of(context).size.width * 0.2).toInt(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: listData.vehiclemainimage != null
                                ? Image.network(
                                    listData.vehiclemainimage.toString(),
                                    filterQuality: FilterQuality.low,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/logo-iihs-in-app.png',
                                    fit: BoxFit.scaleDown,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: (MediaQuery.of(context).size.width * 0.2).toInt(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Center(
                                  child: Text(
                                    listData.makename + ' ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppTheme.darkText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  listData.modelyear,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  listData.seriesname,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        VehicleRatingsResults.routeName,
                        arguments: listData,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
