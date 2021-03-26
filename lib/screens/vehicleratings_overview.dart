import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/modelyears.dart';
import 'package:iihs/utils/apifunctions/vehiclemakes.dart';
import 'package:iihs/utils/apifunctions/vehiclemodels.dart';
import 'package:iihs/utils/apifunctions/vehicleseries.dart';
import 'package:iihs/utils/apifunctions/ratings.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/models/vehicleData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  List<VehicleData> templateList = VehicleData.templateList;
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  List<String> allMakeNamesListed;
  List<String> allMakeSlugsListed;
  List<String> modelNamesListed;
  List<String> modelSlugsListed;
  List<String> seriesNamesListed;
  List<String> modelwithseriesList;

  bool loading = false;
  bool enablemenu = false;

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

  Future<List<String>> getALLMakesData() async {
    List<Map<dynamic, dynamic>> _allvehicleData =
        await VehicleMakes().getALLMakes();
    allMakeNamesListed = mapData2List(_allvehicleData, 'name');
    allMakeSlugsListed = mapData2List(_allvehicleData, 'slug');
    return allMakeNamesListed;
  }

  Future<void> combineModelsSeries(String make) async {
    EasyLoading.show(
      status: 'loading...',
    );
    List<String> tempList = [];
    try {
      List<Map<dynamic, dynamic>> _vehiclemodelsformake =
          await VehicleModels().getModels(make);

      modelNamesListed = mapData2List(_vehiclemodelsformake, 'name');
      modelSlugsListed = mapData2List(_vehiclemodelsformake, 'slug');

      List<Map<dynamic, dynamic>> _vehicleseriesformakemodel;

      for (int i = 0; i <= modelSlugsListed.length - 1; i++) {
        _vehicleseriesformakemodel = await VehicleSeries()
            .getSeriesforMakeModel(make, modelSlugsListed[i]);

        seriesNamesListed = mapData2List(_vehicleseriesformakemodel, 'name');

        //getSeriesforMakeModelData(make, modelSlugsListed[i]);
        tempList.add(seriesNamesListed
            .map((val) => modelNamesListed[i] + val)
            .toList()
            .toString());
      }
      setState(() {
        modelwithseriesList = tempList;
        EasyLoading.dismiss();
        enablemenu = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getModelsforMake(String make) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      List<Map<dynamic, dynamic>> _vehiclemodelsformake =
          await VehicleModels().getModels(make);
      setState(() {
        modelNamesListed = mapData2List(_vehiclemodelsformake, 'name');
        modelSlugsListed = mapData2List(_vehiclemodelsformake, 'slug');
        EasyLoading.dismiss();
        enablemenu = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSeriesforMakeModelData(String make, String model) async {
    try {
      List<Map<dynamic, dynamic>> _vehicleseriesformakemodel =
          await VehicleSeries().getSeriesforMakeModel(make, model);

      seriesNamesListed = mapData2List(_vehicleseriesformakemodel, 'name');
    } catch (e) {
      print(e);
    }
  }

  void getRatingsData() async {
    var yearsData = await ModelYears().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await CrashRatings()
        .crashRatings('2021', 'bmw', '2-series-2-door-coupe');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> makemodelchoice =
        ModalRoute.of(context).settings.arguments;

    log(makemodelchoice.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<String>>(
        future: getALLMakesData(), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) {
            EasyLoading.show(
              status: 'loading...',
            );
            return initialview();
          } else if (snapshot.hasError) {
            EasyLoading.show(
              status: 'loading...',
            );

            return Container(
              child: null,

              // DO SOMETHING !!!!!!!!!!!!!!!!!!!  RETURN BACK ODER SO
            );

            // return Container(
            //   color: AppTheme.iihsbackground_dark,
            //   child: Center(
            //     child: SpinKitCubeGrid(
            //       color: AppTheme.iihsbackground,
            //       size: 100.0,
            //     ),
            //   ),
            // );
          } else {
            EasyLoading.dismiss();
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: Image.network(
                        crashratingpage,
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
                  top: (MediaQuery.of(context).size.height * 0.2),
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.nearlyWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GridView(
                            padding: const EdgeInsets.only(
                                top: 10, left: 12, right: 12),
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
                                  animationvaluechanger:
                                      index % 2 == 0 ? 100 : -100,
                                  listData: templateList[index],
                                  callBack: () {
                                    // Navigator.push<dynamic>(
                                    //   context,
                                    //   MaterialPageRoute<dynamic>(
                                    //     builder: (BuildContext context) =>
                                    //         templateList[index].navigateScreen,
                                    //   ),
                                    // );
                                  },
                                );
                              },
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 15.0,
                              crossAxisSpacing: 15.0,
                              childAspectRatio: 1.5,
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     left: MediaQuery.of(context).size.width * 0.2,
                        //     right: MediaQuery.of(context).size.width * 0.2,
                        //     top: MediaQuery.of(context).size.width * 0.02,
                        //   ),
                        //   child: dropDownMenu('series'),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     left: MediaQuery.of(context).size.width * 0.2,
                        //     right: MediaQuery.of(context).size.width * 0.2,
                        //     top: MediaQuery.of(context).size.width * 0.02,
                        //     bottom: MediaQuery.of(context).size.width * 0.05,
                        //   ),
                        //   child: dropDownMenu('year'),
                        // ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height * 0.15),
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.2,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn,
                    ),
                    child: Card(
                      color: AppTheme.iihsyellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      //elevation: 5.0,
                      child: Container(
                        //   width: MediaQuery.of(context).size.width * 0.6,
                        // height: MediaQuery.of(context).size.height * 0.08,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Vehicle Ratings',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontWeight: FontWeight.w600,
                              fontSize: 22,
                              // letterSpacing: 0.27,
                              color: AppTheme.darkerText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: SizedBox(
                    width: AppBar().preferredSize.height,
                    height: AppBar().preferredSize.height,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                            AppBar().preferredSize.height),
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
        },
      ),
    );
  }

  Widget initialview() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                crashratingpage,
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
          top: (MediaQuery.of(context).size.height * 0.4),
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.width * 0.2,
                  ),
                  child: dropDownMenu('make'),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: dropDownMenu('model'),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height * 0.35),
          left: MediaQuery.of(context).size.width * 0.2,
          right: MediaQuery.of(context).size.width * 0.2,
          child: ScaleTransition(
            alignment: Alignment.center,
            scale: CurvedAnimation(
                parent: animationController, curve: Curves.fastOutSlowIn),
            child: Card(
              color: AppTheme.iihsyellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              //elevation: 5.0,
              child: Container(
                //   width: MediaQuery.of(context).size.width * 0.6,
                // height: MediaQuery.of(context).size.height * 0.08,
                height: 50,
                child: Center(
                  child: Text(
                    'Vehicle Ratings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontWeight: FontWeight.w600,
                      fontSize: 22,
                      // letterSpacing: 0.27,
                      color: AppTheme.darkerText,
                    ),
                  ),
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

  Widget dropDownMenu(String type) {
    var listname;
    String _type;
    bool _enablemenu;
    if (type == 'make') {
      listname = allMakeNamesListed;
      _type = 'Make';
      _enablemenu = true;
    } else if (type == 'model') {
      listname = modelNamesListed;
      _type = 'Model';
      _enablemenu = enablemenu;
    } else if (type == 'series') {
      listname = modelNamesListed;
      _type = 'Series';
      _enablemenu = enablemenu;
    } else if (type == 'year') {
      listname = modelNamesListed;
      _type = 'Year';
      _enablemenu = enablemenu;
    }

    return DropdownSearch<String>(
      validator: (v) => v == null ? "required field" : null,
      hint: 'Select a $_type',
      mode: Mode.DIALOG,
      maxHeight: 300,
      popupTitle: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.iihsyellow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            'Vehicle $_type',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
        ),
      ),
      popupShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.nearlyWhite,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.nearlyBlack,
          ),
        ),
      ),
      showAsSuffixIcons: true,
      dropdownButtonBuilder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Icon(
          Icons.arrow_drop_down,
          size: 24,
          color: Colors.black,
        ),
      ),
      showSelectedItem: false,
      items: listname,
      label: 'Vehicle $_type *',
      enabled: _enablemenu,
      onChanged: (String newValue) {
        if (type == 'make') {
          funcMakeonChanged(newValue);
        } else if (type == 'model') {
          funcModelonChanged(newValue);
        } else if (type == 'series') {
          funcModelonChanged(newValue);
        } else if (type == 'year') {
          funcModelonChanged(newValue);
        }
      },
      //selectedItem: "select a make", // model
    );
  }

  void funcMakeonChanged(value) {
    int index = allMakeNamesListed.indexOf(value);
    setState(() {
      enablemenu = false;
    });
    getModelsforMake(allMakeSlugsListed[index]);
  }

  void funcModelonChanged(value) {
    log(value);
  }
}

class TemplateListView extends StatelessWidget {
  const TemplateListView(
      {Key key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation,
      this.animationvaluechanger})
      : super(key: key);

  final VehicleData listData;
  final VoidCallback callBack;
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
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                child: Stack(
                  // alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    // Image.network(
                    //   listData.name,
                    //   fit: BoxFit.cover,
                    // ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          color: Colors.black45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listData.slug,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0)),
                        onTap: () {
                          callBack();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('An Error Occurred!'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }
