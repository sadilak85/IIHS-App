import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iihs/models/constants/app_theme.dart';
import 'package:iihs/utils/apifunctions/vehiclemakes.dart';
import 'package:iihs/utils/apifunctions/vehiclemodels.dart';
import 'package:iihs/utils/operations/dataoperations.dart';
import 'package:iihs/models/constants/networkimages.dart';
import 'package:iihs/screens/vehiclesOverview.dart';
import 'package:iihs/models/vehicleData.dart';

class VehicleSelectMake extends StatefulWidget {
  static const routeName = '/vehicle-selectionbymake-screen';
  @override
  _VehicleSelectMakeState createState() => _VehicleSelectMakeState();
}

class _VehicleSelectMakeState extends State<VehicleSelectMake>
    with TickerProviderStateMixin {
  // final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;

  String _selectedMakeId;
  String _selectedMakeSlug;
  String _selectedMakeName;
  List<String> allMakeIdsListed;
  List<String> allMakeSlugsListed;
  List<String> allMakeNamesListed;

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

  Future<List<String>> getALLMakesData() async {
    List<Map<dynamic, dynamic>> _allvehicleData =
        await VehicleMakes().getALLMakes();
    allMakeIdsListed = mapData2List(_allvehicleData, 'id');
    allMakeSlugsListed = mapData2List(_allvehicleData, 'slug');
    allMakeNamesListed = mapData2List(_allvehicleData, 'name');
    return allMakeNamesListed;
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
                              top: MediaQuery.of(context).size.width * 0.30,
                              bottom: MediaQuery.of(context).size.width * 0.10,
                            ),
                            child: dropDownMenu(),
                          ),
                          Card(
                            color: AppTheme.iihsyellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 5.0,
                            child: TextButton.icon(
                              onPressed: () {
                                if (readycheck == true) {
                                  VehicleData selectedvehicle = VehicleData(
                                    makeid: _selectedMakeId,
                                    makeslug: _selectedMakeSlug,
                                    makename: _selectedMakeName,
                                  );

                                  Navigator.of(context).pushNamed(
                                    VehicleRatingsOverview.routeName,
                                    arguments: selectedvehicle,
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
                        ],
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

  Widget dropDownMenu() {
    var listname;
    String _type;
    bool _enablemenu;
    bool _ismake;
    _ismake = true;
    listname = allMakeNamesListed;
    _type = 'Makes';
    _enablemenu = true;

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
      label: 'Vehicle $_type',
      enabled: _enablemenu,
      onChanged: (String newValue) {
        funcMakeonChanged(newValue);
      },
      selectedItem: '', // model
    );
  }

  void funcMakeonChanged(value) {
    int index = allMakeNamesListed.indexOf(value);
    _selectedMakeId = allMakeIdsListed[index];
    _selectedMakeSlug = allMakeSlugsListed[index];
    _selectedMakeName = allMakeNamesListed[index];
    readycheck = true;
  }
}
