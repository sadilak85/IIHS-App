import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehiclemakes.dart';
import 'package:iihs/utils/apifunctions/vehiclemodels.dart';
import 'package:iihs/utils/apifunctions/vehicleseries.dart';
import 'package:iihs/utils/apifunctions/vehiclemodelyears.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/screens/main_page.dart';
import 'package:iihs/models/vehicleData.dart';

class VehicleSelectMakeModel extends StatefulWidget {
  static const routeName = '/vehicle-selectionbymakemodel-screen';

  @override
  _VehicleSelectMakeModelState createState() => _VehicleSelectMakeModelState();
}

class _VehicleSelectMakeModelState extends State<VehicleSelectMakeModel>
    with TickerProviderStateMixin {
  //
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

  String _selectedYearsName;
  String _selectedmodeldropdown = '';
  String _selectedseriesdropdown = '';
  String _selectedyearsdropdown = '';
  List<String> allMakeIdsListed, allMakeSlugsListed, allMakeNamesListed;
  List<String> modelIdsListed, modelSlugsListed, modelNamesListed;
  List<String> seriesIdsListed,
      seriesVariantTypeIdsListed,
      seriesSlugsListed,
      seriesiihsUrlsListed,
      seriesNamesListed;
  List<String> modelYearsListed;

  bool enableModelmenu = false;
  bool enableSeriesmenu = false;
  bool enableYearsmenu = false;
  bool makereadycheck = false;
  bool modelreadycheck = false;
  bool seriesreadycheck = false;
  bool yearsreadycheck = false;
  bool displayModelBox = false;
  bool displaySeriesBox = false;
  bool displayYearsBox = false;
  bool displaySearchButton = false;

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
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> setData() async {
    animationController.forward();
  }
  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   //if (info.ifRouteChanged(context)) return false;

  //   //Navigator.of(context, rootNavigator: true).pop();

  //   Navigator.pop(context);
  //   return true;
  // }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
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
        //_selectedmodeldropdown = modelNamesListed[0];
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
        // _selectedseriesdropdown = seriesNamesListed[0];
      });
    } catch (e) {
      print(e);
    }
  }

  // After series selected, years list is shown:
  Future<void> getYearsDataforMakeModelSeries(
      String make, String series) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      modelYearsListed = await ModelYears().getModelYearsforMakeModelSeries(
        make,
        series,
      );
      setState(() {
        EasyLoading.dismiss();
        enableYearsmenu = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Missing field:'),
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

  void onClose() {
    EasyLoading.dismiss();
    if (_connectionStatus == 'ConnectivityResult.none') {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          maintainState: true,
          opaque: true,
          pageBuilder: (context, _, __) => MainPageScreen(),
          transitionDuration: const Duration(seconds: 2),
          transitionsBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              child: child,
              opacity: anim1,
            );
          },
        ),
      );
    } else {
      EasyLoading.showSuccess('online');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));

    if (_connectionStatus == 'ConnectivityResult.none') {
      EasyLoading.show(
          status: 'Oops! Check your internet connection to proceed!.');
      Timer(const Duration(seconds: 5), onClose);
    }

    return _connectionStatus == 'Unknown'
        ? SizedBox()
        : _connectionStatus == 'ConnectivityResult.none'
            ? Container(
                color: AppTheme.nearlyWhite,
                child: Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/images/NetworkDown.png',
                            height: MediaQuery.of(context).size.height * 0.3,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppTheme.iihsbackground,
                body: FutureBuilder<List<String>>(
                  future: getALLMakesData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitDoubleBounce(
                          color: AppTheme.nearlyBlack,
                          size: 100.0,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SpinKitDoubleBounce(
                          color: AppTheme.nearlyBlack,
                          size: 100.0,
                        ),
                      );
                    } else {
                      return Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 1.5,
                                child: Image.network(
                                  selectiontopimage,
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
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: (MediaQuery.of(context).size.height * 0.25),
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
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      decoration: BoxDecoration(
                                        color: AppTheme.iihsyellow,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Vehicle Ratings',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                      child: dropDownMenu('make'),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          ScaleTransition(
                                              child: child, scale: animation),
                                      child: displayModelBox
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              child: dropDownMenu('model'),
                                            )
                                          : SizedBox(),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          ScaleTransition(
                                              child: child, scale: animation),
                                      child: displaySeriesBox
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              child: dropDownMenu('series'),
                                            )
                                          : SizedBox(),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          ScaleTransition(
                                              child: child, scale: animation),
                                      child: displayYearsBox
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              child: dropDownMenu('years'),
                                            )
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.25,
                            right: MediaQuery.of(context).size.width * 0.25,
                            bottom: (MediaQuery.of(context).size.height * 0.04),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: displaySearchButton
                                  ? ScaleTransition(
                                      alignment: Alignment.center,
                                      scale: CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn),
                                      child: Card(
                                        color: AppTheme.iihsyellow,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        elevation: 5.0,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            if (makereadycheck == false) {
                                              _showErrorDialog(
                                                  'Select a vehicle make!');
                                            } else if (modelreadycheck ==
                                                false) {
                                              _showErrorDialog(
                                                  'Select a vehicle model!');
                                            } else if (seriesreadycheck ==
                                                false) {
                                              _showErrorDialog(
                                                  'Select a model serie!');
                                            } else if (yearsreadycheck ==
                                                false) {
                                              _showErrorDialog(
                                                  'Select a year for serie!');
                                            } else {
                                              selectedvehicle = VehicleData(
                                                makeid: _selectedMakeId,
                                                makeslug: _selectedMakeSlug,
                                                makename: _selectedMakeName,
                                                modelid: _selectedModelId,
                                                modelslug: _selectedModelSlug,
                                                modelname: _selectedModelName,
                                                modelyear: _selectedYearsName,
                                                seriesid: _selectedSeriesId,
                                                seriesvariantTypeId:
                                                    _selectedVariantTypeId,
                                                seriesslug: _selectedSeriesSlug,
                                                seriesiihsUrl:
                                                    _selectedSeriesiihsUrl,
                                                seriesname: _selectedSeriesName,
                                              );

                                              Navigator.pushNamed(
                                                context,
                                                "/ratings",
                                                arguments: selectedvehicle,
                                              );
                                            }
                                          },
                                          label: Text(
                                            '',
                                          ),
                                          icon: Row(
                                            children: [
                                              Icon(
                                                Icons.directions_car_outlined,
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_right,
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
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: AppBar().preferredSize.height,
                                height: AppBar().preferredSize.height,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                        AppBar().preferredSize.height),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(
                                            AppBar().preferredSize.height),
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_sharp,
                                        size: 25.0,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              );
  }

  Widget dropDownMenu(String type) {
    var itemlist;
    String _type;
    bool _enablemenu;
    bool _ismake, _isyear;
    if (type == 'make') {
      _ismake = true;
      _isyear = false;
      itemlist = allMakeNamesListed;
      _type = 'Makes';
      _enablemenu = true;
    } else if (type == 'model') {
      _ismake = false;
      _isyear = false;
      itemlist = modelNamesListed;
      _type = 'Models';
      _enablemenu = enableModelmenu;
    } else if (type == 'series') {
      _ismake = false;
      _isyear = false;
      itemlist = seriesNamesListed;
      _type = 'Series';
      _enablemenu = enableSeriesmenu;
    } else if (type == 'years') {
      _ismake = false;
      _isyear = true;
      itemlist = modelYearsListed != null
          ? modelYearsListed.reversed.toList()
          : modelYearsListed;
      _type = 'Year';
      _enablemenu = enableYearsmenu;
    }

    return DropdownSearch<String>(
      // showSearchBox: _ismake ? true : false,
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
            _ismake
                ? 'Vehicle $_type'
                : _isyear
                    ? 'Select a year'
                    : '$_selectedMakeName $_type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkerText,
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
      //validator: (v) => v == null ? "required field" : null,
      showAsSuffixIcons: true,
      dropdownButtonBuilder: (_) => const Icon(
        Icons.arrow_drop_down,
        size: 24,
        color: Colors.black,
      ),
      showSelectedItem: true,
      selectedItem: (type == 'model')
          ? _selectedmodeldropdown
          : (type == 'series')
              ? _selectedseriesdropdown
              : (type == 'years')
                  ? _selectedyearsdropdown
                  : null,

      popupItemBuilder: _customPopupItemBuilder,
      items: itemlist,
      label: _isyear ? '$_type' : 'Vehicle $_type',
      enabled: _enablemenu,
      onChanged: (String newValue) {
        if (type == 'make') {
          funcMakeonChanged(newValue);
        } else if (type == 'model') {
          funcModelonChanged(newValue);
        } else if (type == 'series') {
          funcSeriesonChanged(newValue);
        } else if (type == 'years') {
          funcYearsonChanged(newValue);
        }
      },
    );
  }

  void funcMakeonChanged(value) {
    if (value != null) {
      int index = allMakeNamesListed.indexOf(value);
      _selectedMakeId = allMakeIdsListed[index];
      _selectedMakeSlug = allMakeSlugsListed[index];
      _selectedMakeName = allMakeNamesListed[index];
      modelreadycheck = false;
      seriesreadycheck = false;
      yearsreadycheck = false;
      setState(() {
        _selectedmodeldropdown = null;
        enableModelmenu = false;
        displayModelBox = true;
        displaySeriesBox = false;
        displayYearsBox = false;
        displaySearchButton = false;
      });
      getModelsforMake(_selectedMakeSlug);
      makereadycheck = true;
    } else {
      setState(() {
        displayModelBox = false;
        displaySeriesBox = false;
        displayYearsBox = false;
        displaySearchButton = false;
      });
      makereadycheck = false;
    }
  }

  void funcModelonChanged(value) {
    if (value != null) {
      int index = modelNamesListed.indexOf(value);
      _selectedModelId = modelIdsListed[index];
      _selectedModelSlug = modelSlugsListed[index];
      _selectedModelName = modelNamesListed[index];
      seriesreadycheck = false;
      yearsreadycheck = false;
      _selectedmodeldropdown = _selectedModelName;
      setState(() {
        _selectedseriesdropdown = null;
        _selectedyearsdropdown = null;
        enableSeriesmenu = false;
        enableYearsmenu = false;
        displaySeriesBox = true;
      });
      getSeriesDataforMakeModel(_selectedMakeSlug, _selectedModelSlug);
      modelreadycheck = true;
    } else {
      setState(() {
        displaySeriesBox = false;
        displayYearsBox = false;
        displaySearchButton = false;
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
      yearsreadycheck = false;
      _selectedseriesdropdown = _selectedSeriesName;
      setState(() {
        _selectedyearsdropdown = null;
        enableYearsmenu = false;
        displayYearsBox = true;
      });
      getYearsDataforMakeModelSeries(_selectedMakeSlug, _selectedSeriesSlug);
      seriesreadycheck = true;
    } else {
      setState(() {
        displayYearsBox = false;
        displaySearchButton = false;
      });
      seriesreadycheck = false;
    }
  }

  void funcYearsonChanged(value) {
    if (value != null) {
      int index = modelYearsListed.indexOf(value);
      _selectedYearsName = modelYearsListed[index];
      _selectedyearsdropdown = _selectedYearsName;
      setState(() {
        displaySearchButton = true;
      });
      yearsreadycheck = true;
    } else {
      setState(() {
        displaySearchButton = false;
      });
      yearsreadycheck = false;
    }
  }

  Widget _customPopupItemBuilder(
      BuildContext context, String item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                // border: Border.all(color: AppTheme.nearlyBlack),
                borderRadius: BorderRadius.circular(15),
                color: AppTheme.iihsyellow,
              ),
        child: ListTile(
          selected: isSelected,
          title: Text(
            item,
            style: TextStyle(
              color: AppTheme.darkerText,
            ),
          ),
        ),
      ),
    );
  }
}
