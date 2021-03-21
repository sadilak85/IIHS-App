import 'package:flutter/material.dart';
import 'package:iihs/constants/app_theme.dart';
import 'package:iihs/operations/modelyears.dart';
import 'package:iihs/operations/vehiclemakes.dart';
import 'package:iihs/operations/ratings.dart';
import 'package:iihs/constants/networkimages.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
//import 'package:direct_select/direct_select.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:iihs/widgets/directselect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  GlobalKey<AutoCompleteTextFieldState<String>> key2 = GlobalKey();
  String _selectedMake;
  bool keyboardison;

  List<Map<dynamic, dynamic>> allvehiclemakesData;
  List<String> allvehiclemakesDataNames = [];

  int selectedIndex1 = 0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    getALLMakeModelData();
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

  Future<List<String>> getALLMakeModelData() async {
    var tempList = await VehicleMakes().getALLMakes();
    allvehiclemakesData = tempList;

    for (int i = 0; i <= allvehiclemakesData.length - 1; i++) {
      allvehiclemakesDataNames.add(allvehiclemakesData[i]['name'].toString());
    }
    return allvehiclemakesDataNames;
  }

  void getRatingsData() async {
    var yearsData = await ModelYears().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await CrashRatings()
        .crashRatings('2021', 'bmw', '2-series-2-door-coupe');

    log(data.toString());
  }

  List<Widget> _buildItems1() {
    return allvehiclemakesDataNames
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      keyboardison = true;
    } else {
      keyboardison = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<String>>(
        future: getALLMakeModelData(), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitCubeGrid(
                color: AppTheme.iihsbackground,
                size: 100.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SpinKitCubeGrid(
                color: AppTheme.iihsbackground,
                size: 100.0,
              ),
            );
          } else {
            return DirectSelectContainer(
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
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                    top: keyboardison
                        ? (MediaQuery.of(context).size.height * 0.15)
                        : (MediaQuery.of(context).size.height * 0.4),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.08,
                            // ),
                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 62,
                                              top: 32,
                                              bottom: 12),
                                          child: SimpleAutoCompleteTextField(
                                            key: key,
                                            suggestions:
                                                allvehiclemakesDataNames,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.directions_car,
                                                  size: 30),
                                              errorStyle: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16.0),
                                              filled: true,
                                              fillColor:
                                                  AppTheme.iihsbackground,
                                              hintText: 'Vehicle Make',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),

                                            textChanged: (text) =>
                                                _selectedMake = text,

                                            textSubmitted: (text) => log(text),

//  (String newValue) {
//                                                 setState(() {
//                                                   _currentSelectedValue =
//                                                       newValue;
//                                                   state.didChange(newValue);
//                                                 });

                                            // (text) => setState(() {

                                            //     }),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0, right: 62),
                                          child: DirectSelectList<String>(
                                              values: allvehiclemakesDataNames,
                                              defaultItemIndex: selectedIndex1,
                                              itemBuilder: (String value) =>
                                                  getDropDownMenuItem(value),
                                              focusedItemDecoration:
                                                  _getDslDecoration(),
                                              onItemSelectedListener:
                                                  (item, index, context) {
                                                setState(() {
                                                  selectedIndex1 = index;
                                                });
                                              }),

                                          // DirectSelect(
                                          //   itemExtent: 35.0,
                                          //   selectedIndex: selectedIndex1,
                                          //   backgroundColor:
                                          //       AppTheme.iihsbackground,
                                          //   child: MySelectionItem(
                                          //     isForList: false,
                                          //     title: allvehiclemakesDataNames[
                                          //         selectedIndex1],
                                          //   ),
                                          //   onSelectedItemChanged: (index) {
                                          //     setState(() {
                                          //       selectedIndex1 = index;
                                          //     });
                                          //   },
                                          //   items: _buildItems1(),
                                          // ),

                                          // SimpleAutoCompleteTextField(
                                          //   key: key2,
                                          //   suggestions: allvehiclemakesDataNames,
                                          //   decoration: InputDecoration(
                                          //     icon: Icon(Icons.content_copy, size: 30),
                                          //     errorStyle: TextStyle(
                                          //         color: Colors.redAccent,
                                          //         fontSize: 16.0),
                                          //     filled: true,
                                          //     fillColor: AppTheme.iihsbackground,
                                          //     hintText: 'Vehicle Model',
                                          //     border: OutlineInputBorder(
                                          //       borderRadius:
                                          //           BorderRadius.circular(5.0),
                                          //     ),
                                          //   ),
                                          //   textChanged: (text) => _selectedMake = text,
                                          //   textSubmitted: (text) => log(text),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 16, right: 16),
                                child: TextButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    // if (this._formKey.currentState.validate()) {
                                    //   // log(this._formKey.currentState.toString());
                                    //   this._formKey.currentState.save();
                                    // }
                                  },

                                  // height: 48,
                                  // decoration: BoxDecoration(
                                  //   color: AppTheme.iihsyellow,
                                  //   borderRadius: const BorderRadius.all(
                                  //     Radius.circular(16.0),
                                  //   ),
                                  //   boxShadow: <BoxShadow>[
                                  //     BoxShadow(
                                  //         color: AppTheme.iihsyellow.withOpacity(0.5),
                                  //         offset: const Offset(1.1, 1.1),
                                  //         blurRadius: 10.0),
                                  //   ],
                                  // ),
                                  // child: Center(
                                  //   child: Text(
                                  //     'Join Course',
                                  //     textAlign: TextAlign.left,
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.w600,
                                  //       fontSize: 18,
                                  //       letterSpacing: 0.0,
                                  //       color: AppTheme.nearlyWhite,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: keyboardison
                        ? (MediaQuery.of(context).size.height * 0.10)
                        : (MediaQuery.of(context).size.height * 0.35),
                    right: MediaQuery.of(context).size.width * 0.2,
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn),
                      child: Card(
                        color: AppTheme.iihsbackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        //elevation: 5.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          // height: MediaQuery.of(context).size.height * 0.08,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Vehicle Ratings',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: AppTheme.darkerText,
                              ),
                            ),
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
            );
          }
        },
      ),
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

// FormField<String>(
//                                       builder: (FormFieldState<String> state) {
//                                         return InputDecorator(
//                                           decoration: InputDecoration(
//                                               //  labelStyle: ,
//                                               icon:
//                                                   Icon(Icons.search, size: 50),
//                                               errorStyle: TextStyle(
//                                                   color: Colors.redAccent,
//                                                   fontSize: 16.0),
//                                               hintText: 'Please select expense',
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           5.0))),
//                                           isEmpty: _currentSelectedValue == '',
//                                           child: DropdownButtonHideUnderline(
//                                             child: DropdownButton<String>(
//                                               value: _currentSelectedValue,
//                                               isDense: true,
//                                               onChanged: (String newValue) {
//                                                 setState(() {
//                                                   _currentSelectedValue =
//                                                       newValue;
//                                                   state.didChange(newValue);
//                                                 });
//                                               },
//                                               items:

//                                                   // allvehiclemakesData?.map(
//                                                   //         (VehicleMakesData value) {
//                                                   //       return DropdownMenuItem<
//                                                   //           VehicleMakesData>(
//                                                   //         value: value,
//                                                   //         child: Text(
//                                                   //           value.name,
//                                                   //           style: TextStyle(
//                                                   //               fontSize: 16.0),
//                                                   //         ),
//                                                   //       );
//                                                   //     })?.toList() ??
//                                                   //     [],

//                                                   ['a', 'b', 'c']
//                                                       .map((String value) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: value,
//                                                   child: Text(value),
//                                                 );
//                                               }).toList(),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
