import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehiclemakes.dart';
import 'package:iihs/utils/apifunctions/vehiclemodels.dart';
import 'package:iihs/utils/apifunctions/vehicleseries.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/screens/vehiclesOverview.dart';
import 'package:iihs/models/vehicleData.dart';
import 'dart:developer';

class VehicleSelectMakeModel extends StatefulWidget {
  static const routeName = '/vehicle-selectionbymakemodel-screen';
  @override
  _VehicleSelectMakeModelState createState() => _VehicleSelectMakeModelState();
}

class _VehicleSelectMakeModelState extends State<VehicleSelectMakeModel>
    with TickerProviderStateMixin {
  // final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  VehicleData selectedvehicle;
  String _selectedMakeId, _selectedMakeSlug, _selectedMakeName;
  String _selectedModelId, _selectedModelSlug, _selectedModelName;
  String _selectedSeriesId,
      _selectedVariantTypeId,
      _selectedSeriesSlug,
      _selectedSeriesiihsUrl,
      _selectedSeriesName;
  List<String> allMakeIdsListed, allMakeSlugsListed, allMakeNamesListed;
  List<String> modelIdsListed, modelSlugsListed, modelNamesListed;
  List<String> seriesIdsListed,
      seriesVariantTypeIdsListed,
      seriesSlugsListed,
      seriesiihsUrlsListed,
      seriesNamesListed;

  bool enableModelmenu = false;
  bool enableSeriesmenu = false;
  bool modelreadycheck = false;
  bool seriesreadycheck = false;
  bool displayModelBox = false;
  bool displaySeriesBox = false;
  bool displaySearchBox = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    setData();
    _selectedMakeName = 'Vehicle';
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

// First get all available makes as a list to create a list for user choice:
  Future<List<String>> getALLMakesData() async {
    List<Map<dynamic, dynamic>> _allvehicleData =
        await VehicleMakes().getALLMakes();
    allMakeIdsListed = mapData2List(_allvehicleData, 'id');
    allMakeSlugsListed = mapData2List(_allvehicleData, 'slug');
    allMakeNamesListed = mapData2List(_allvehicleData, 'name');
    return allMakeNamesListed;
  }

// After make selected, get the corresponding models as a list:
  Future<void> getModelsforMake(String make) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      List<Map<dynamic, dynamic>> _vehiclemodelsformake =
          await VehicleModels().getModels(make);
      modelIdsListed = mapData2List(_vehiclemodelsformake, 'id');
      modelSlugsListed = mapData2List(_vehiclemodelsformake, 'slug');
      modelNamesListed = mapData2List(_vehiclemodelsformake, 'name');
      setState(() {
        EasyLoading.dismiss();
        enableModelmenu = true;
      });
    } catch (e) {
      print(e);
    }
  }

// After make and model selected, get the corresponding series for make and model as a list:
  Future<void> getSeriesDataforMakeModel(String make, String model) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      List<Map<dynamic, dynamic>> _vehicleseriesformakemodel;
      _vehicleseriesformakemodel = await VehicleSeries().getSeriesforMakeModel(
        make,
        model,
      );
      seriesIdsListed = mapData2List(_vehicleseriesformakemodel, 'id');
      seriesVariantTypeIdsListed =
          mapData2List(_vehicleseriesformakemodel, 'variantTypeId');
      seriesSlugsListed = mapData2List(_vehicleseriesformakemodel, 'slug');
      seriesiihsUrlsListed =
          mapData2List(_vehicleseriesformakemodel, 'iihsUrl');
      seriesNamesListed = mapData2List(_vehicleseriesformakemodel, 'name');

      setState(() {
        EasyLoading.dismiss();
        enableSeriesmenu = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('To be precise:'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<String>>(
        future: getALLMakesData(), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: AppTheme.iihsbackground_dark,
              child: Center(
                child: SpinKitCubeGrid(
                  color: AppTheme.iihsbackground,
                  size: 100.0,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: AppTheme.iihsbackground_dark,
              child: Center(
                child: SpinKitCubeGrid(
                  color: AppTheme.iihsbackground,
                  size: 100.0,
                ),
              ),
            );
          } else {
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
                  top: (MediaQuery.of(context).size.height * 0.38),
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
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
                              top: MediaQuery.of(context).size.height * 0.08,
                            ),
                            child: dropDownMenu('make'),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (Widget child,
                                    Animation<double> animation) =>
                                ScaleTransition(child: child, scale: animation),
                            child: displayModelBox
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.2,
                                      right: MediaQuery.of(context).size.width *
                                          0.2,
                                      top: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                    child: dropDownMenu('model'),
                                  )
                                : SizedBox(),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (Widget child,
                                    Animation<double> animation) =>
                                ScaleTransition(child: child, scale: animation),
                            child: displaySeriesBox
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.2,
                                      right: MediaQuery.of(context).size.width *
                                          0.2,
                                      top: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                    child: dropDownMenu('series'),
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height * 0.33),
                  left: MediaQuery.of(context).size.width * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: CurvedAnimation(
                        parent: animationController,
                        curve: Curves.fastOutSlowIn),
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
                              fontSize: 18,
                              // letterSpacing: 0.27,
                              color: AppTheme.darkerText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.35,
                  right: MediaQuery.of(context).size.width * 0.35,
                  bottom: (MediaQuery.of(context).size.height * 0.05),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1500),
                    child: displaySearchBox
                        ? ScaleTransition(
                            alignment: Alignment.center,
                            scale: CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn),
                            child: Card(
                              color: AppTheme.iihsyellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              elevation: 5.0,
                              child: TextButton.icon(
                                onPressed: () {
                                  if (modelreadycheck == false) {
                                    _showErrorDialog('Select a vehicle model!');
                                  } else if (seriesreadycheck == false) {
                                    _showErrorDialog('Select a model serie!');
                                  } else {
                                    selectedvehicle = VehicleData(
                                      makeid: _selectedMakeId,
                                      makeslug: _selectedMakeSlug,
                                      makename: _selectedMakeName,
                                      modelid: _selectedModelId,
                                      modelslug: _selectedModelSlug,
                                      modelname: _selectedModelName,
                                      seriesid: _selectedSeriesId,
                                      seriesslug: _selectedSeriesSlug,
                                      seriesname: _selectedSeriesName,
                                    );
                                    Navigator.of(context).pushNamed(
                                      VehicleRatingsOverview.routeName,
                                      arguments: selectedvehicle,
                                    );
                                  }
                                },
                                label: Text(
                                  '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    // letterSpacing: 0.27,
                                  ),
                                ),
                                icon: Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car_outlined,
                                    ),
                                    Icon(
                                      Icons.search,
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  minimumSize: Size(150, 50),
                                  primary: AppTheme.darkText,
                                  //  backgroundColor: AppTheme.iihsyellow,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
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

  Widget dropDownMenu(String type) {
    var listname;
    String _type;
    bool _enablemenu;
    bool _ismake;
    if (type == 'make') {
      _ismake = true;
      listname = allMakeNamesListed;
      _type = 'Makes';
      _enablemenu = true;
    } else if (type == 'model') {
      _ismake = false;
      listname = modelNamesListed;
      _type = 'Models';
      _enablemenu = enableModelmenu;
    } else if (type == 'series') {
      _ismake = false;
      listname = seriesNamesListed;
      _type = 'Series';
      _enablemenu = enableSeriesmenu;
    }

    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      maxHeight: MediaQuery.of(context).size.height * 0.7,
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
            _ismake ? 'Vehicle $_type' : '$_selectedMakeName $_type',
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
      showClearButton: !_ismake,
      clearButtonBuilder: (_) => const Icon(
        Icons.clear,
        size: 18,
        color: Colors.black,
      ),
      validator: (v) => v == null ? "required field" : null,
      showAsSuffixIcons: true,
      dropdownButtonBuilder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Icon(
          Icons.arrow_drop_down,
          size: 24,
          color: Colors.black,
        ),
      ),
      showSelectedItem: true,
      items: listname,
      label: 'Vehicle $_type',
      enabled: _enablemenu,
      onChanged: (String newValue) {
        if (type == 'make') {
          funcMakeonChanged(newValue);
        } else if (type == 'model') {
          funcModelonChanged(newValue);
        } else if (type == 'series') {
          funcSeriesonChanged(newValue);
        }
      },
      selectedItem: '', // model
    );
  }

  void funcMakeonChanged(value) {
    int index = allMakeNamesListed.indexOf(value);
    _selectedMakeId = allMakeIdsListed[index];
    _selectedMakeSlug = allMakeSlugsListed[index];
    _selectedMakeName = allMakeNamesListed[index];
    setState(() {
      enableModelmenu = false;
      displayModelBox = true;
    });
    getModelsforMake(_selectedMakeSlug);
  }

  void funcModelonChanged(value) {
    if (value != null) {
      int index = modelNamesListed.indexOf(value);
      _selectedModelId = modelIdsListed[index];
      _selectedModelSlug = modelSlugsListed[index];
      _selectedModelName = modelNamesListed[index];
      modelreadycheck = true;
      setState(() {
        enableSeriesmenu = false;
        displaySeriesBox = true;
      });
      getSeriesDataforMakeModel(_selectedMakeSlug, _selectedModelSlug);
    } else {
      setState(() {
        enableSeriesmenu = false;
        displaySeriesBox = false;
      });
      modelreadycheck = false;
    }
  }

  void funcSeriesonChanged(value) {
    if (value != null) {
      int index = seriesNamesListed.indexOf(value);
      _selectedSeriesId = seriesIdsListed[index];
      _selectedVariantTypeId = seriesVariantTypeIdsListed[index];
      _selectedSeriesSlug = seriesSlugsListed[index];
      _selectedSeriesiihsUrl = seriesiihsUrlsListed[index];
      _selectedSeriesName = seriesNamesListed[index];
      seriesreadycheck = true;
      setState(() {
        displaySearchBox = true;
      });
    } else {
      setState(() {
        displaySearchBox = false;
      });
      seriesreadycheck = false;
    }
  }
}
