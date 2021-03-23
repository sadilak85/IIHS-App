import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/operations/modelyears.dart';
import 'package:iihs/utils/operations/vehiclemakes.dart';
import 'package:iihs/utils/operations/vehiclemodels.dart';
import 'package:iihs/utils/operations/ratings.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:developer';

class VehicleRatings extends StatefulWidget {
  static const routeName = '/findmy-screen';
  @override
  _VehicleRatingsState createState() => _VehicleRatingsState();
}

class _VehicleRatingsState extends State<VehicleRatings>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> allvehicleMakeNamesListed;
  List<String> allvehicleMakeSlugsListed;
  List<String> vehiclemodelNamesListed;

  bool loading = false;
  bool enablemenu = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));

    setData();
    getALLMakesData();

    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  List<String> mapData2List(data, key) {
    List<String> allDataListed = [];
    for (int i = 0; i <= data.length - 1; i++) {
      allDataListed.add(data[i][key].toString());
    }
    return allDataListed;
  }

  Future<List<String>> getALLMakesData() async {
    List<Map<dynamic, dynamic>> _allvehicleData =
        await VehicleMakes().getALLMakes();

    allvehicleMakeNamesListed = mapData2List(_allvehicleData, 'name');
    allvehicleMakeSlugsListed = mapData2List(_allvehicleData, 'slug');

    return allvehicleMakeNamesListed;
  }

  void getModelsforMake(String make) async {
    EasyLoading.show(
      status: 'loading...',
    );

    List<Map<dynamic, dynamic>> _vehiclemodelsformake =
        await VehicleModels().getModels(make);

    setState(() {
      vehiclemodelNamesListed = mapData2List(_vehiclemodelsformake, 'name');
      EasyLoading.dismiss();
      enablemenu = true;
    });
  }

  void getRatingsData() async {
    var yearsData = await ModelYears().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await CrashRatings()
        .crashRatings('2021', 'bmw', '2-series-2-door-coupe');
  }

  @override
  Widget build(BuildContext context) {
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
                              left: 82.0, right: 82, top: 52, bottom: 22),
                          child: dropDownMenu('make'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 82.0, right: 82, bottom: 52),
                          child: dropDownMenu('model'),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity3,
                          child: Card(
                            color: AppTheme.iihsyellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 5.0,
                            child: TextButton.icon(
                              onPressed: () {
                                // DO SOMETHING
                              },
                              icon: Icon(
                                Icons.directions_car,
                              ),
                              label: Text(
                                'Search',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  // letterSpacing: 0.27,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: Size(150, 50),
                                primary: AppTheme.darkText,
                                //  backgroundColor: AppTheme.iihsyellow,
                              ),
                            ),
                          ),
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

  Widget dropDownMenu(String type) {
    var listname;
    String _type;
    bool _enablemenu;
    if (type == 'make') {
      listname = allvehicleMakeNamesListed;
      _type = 'Make';
      _enablemenu = true;
    }

    if (type == 'model') {
      listname = vehiclemodelNamesListed;
      _type = 'Model';
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
        }
        if (type == 'model') {
          funcModelonChanged(newValue);
        }
      },
      //selectedItem: "select a make", // model
    );
  }

  void funcMakeonChanged(value) {
    int index = allvehicleMakeNamesListed.indexOf(value);
    setState(() {
      enablemenu = false;
    });
    getModelsforMake(allvehicleMakeSlugsListed[index]);
  }

  void funcModelonChanged(value) {
    log(value);
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
