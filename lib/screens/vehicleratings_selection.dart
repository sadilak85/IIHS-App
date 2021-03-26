import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehiclemakes.dart';
import 'package:iihs/utils/apifunctions/vehiclemodels.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/screens/vehicleratings_overview.dart';

class VehicleRatingsSelection extends StatefulWidget {
  static const routeName = '/vehicleratings-selection-screen';
  @override
  _VehicleRatingsSelectionState createState() =>
      _VehicleRatingsSelectionState();
}

class _VehicleRatingsSelectionState extends State<VehicleRatingsSelection>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  String _selectedMakeSlug;
  String _selectedMakeName;
  String _selectedModelSlug;
  List<String> allMakeNamesListed;
  List<String> allMakeSlugsListed;
  List<String> modelNamesListed;
  List<String> modelSlugsListed;

  bool loading = false;
  bool enablemenu = false;
  bool readycheck = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.bounceIn),
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

  Future<List<String>> getALLMakesData() async {
    List<Map<dynamic, dynamic>> _allvehicleData =
        await VehicleMakes().getALLMakes();
    allMakeNamesListed = mapData2List(_allvehicleData, 'name');
    allMakeSlugsListed = mapData2List(_allvehicleData, 'slug');
    return allMakeNamesListed;
  }

  Future<void> getModelsforMake(String make) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      List<Map<dynamic, dynamic>> _vehiclemodelsformake =
          await VehicleModels().getModels(make);
      modelNamesListed = mapData2List(_vehiclemodelsformake, 'name');
      modelSlugsListed = mapData2List(_vehiclemodelsformake, 'slug');
      setState(() {
        EasyLoading.dismiss();
        enablemenu = true;
      });
    } catch (e) {
      print(e);
    }
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
            return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        100 * (1.0 - animation.value), 0.0, 0.0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.2,
                              child: Image.network(
                                crashratingpage,
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
                                    left:
                                        MediaQuery.of(context).size.width * 0.2,
                                    right:
                                        MediaQuery.of(context).size.width * 0.2,
                                    top:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  child: dropDownMenu('make'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.2,
                                    right:
                                        MediaQuery.of(context).size.width * 0.2,
                                    top: MediaQuery.of(context).size.width *
                                        0.05,
                                    bottom:
                                        MediaQuery.of(context).size.width * 0.1,
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
                        Positioned(
                          bottom: (MediaQuery.of(context).size.height * 0.1),
                          // top: (MediaQuery.of(context).size.height * 0.35),
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
                              elevation: 5.0,
                              child: TextButton.icon(
                                onPressed: () {
                                  if (readycheck == true) {
                                    List<String> makemodelchoice = [
                                      _selectedMakeSlug,
                                      _selectedModelSlug
                                    ];
                                    Navigator.of(context).pushNamed(
                                      VehicleRatingsOverview.routeName,
                                      arguments: makemodelchoice,
                                    );
                                  }
                                },
                                label: Text(
                                  'Search',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    // letterSpacing: 0.27,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.directions_car,
                                ),
                                style: TextButton.styleFrom(
                                  minimumSize: Size(150, 50),
                                  primary: AppTheme.darkText,
                                  //  backgroundColor: AppTheme.iihsyellow,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
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
                    ),
                  ),
                );
              },
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
      _enablemenu = enablemenu;
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
        }
      },
      selectedItem: '', // model
    );
  }

  void funcMakeonChanged(value) {
    int index = allMakeNamesListed.indexOf(value);
    _selectedMakeSlug = allMakeSlugsListed[index];
    _selectedMakeName = allMakeNamesListed[index];
    setState(() {
      enablemenu = false;
    });
    getModelsforMake(_selectedMakeSlug);
  }

  void funcModelonChanged(value) {
    int index = modelNamesListed.indexOf(value);
    _selectedModelSlug = modelSlugsListed[index];
    readycheck = true;
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
