import 'package:flutter/material.dart';
import 'package:iihs/helpers/app_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iihs/models/modelyears.dart';
import 'package:iihs/models/ratings.dart';
import 'package:iihs/constants/networkimages.dart';

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

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool showSpinner = false;
  String dropdownValue = 'Enter';
  String _currentSelectedValue;
  var _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    getRatingsData();
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

  void getRatingsData() async {
    var yearsData = await ModelYears().getModelYears();
    String year = yearsData[yearsData.length - 1]; // a sample

    var data = await CrashRatings()
        .crashRatings('2021', 'bmw', '2-series-2-door-coupe');

    log(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
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
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
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
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              'Vehicle Crash Rating',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: AppTheme.darkerText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          //  labelStyle: ,
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'Please select expense',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: _currentSelectedValue == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _currentSelectedValue,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _currentSelectedValue = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items:
                                              _currencies.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Container(
                                //     color: AppTheme.white,
                                //     child: DropdownButton<String>(
                                //       icon:
                                //           const Icon(Icons.keyboard_arrow_down),
                                //       iconSize: 24,
                                //       elevation: 16,
                                //       style: const TextStyle(
                                //           color: Colors.deepPurple),
                                //       items: <String>['A', 'B', 'C', 'D']
                                //           .map((String value) {
                                //         return DropdownMenuItem<String>(
                                //           value: value,
                                //           child: Text(value),
                                //         );
                                //       }).toList(),
                                //       onChanged: (_) {},
                                //     )),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 48,
                                    height: 48,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.nearlyWhite,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        border: Border.all(
                                            color:
                                                AppTheme.grey.withOpacity(0.2)),
                                      ),
                                      child: Icon(
                                        Icons.arrow_downward,
                                        color: AppTheme.iihsyellow,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppTheme.iihsyellow,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.iihsyellow
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Join Course',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: AppTheme.nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
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
        ),
      ),
    );
  }
}

//  DropdownButton<String>(
//             value: dropdownValue,
//             icon: const Icon(Icons.arrow_downward),
//             iconSize: 24,
//             elevation: 16,
//             style: const TextStyle(color: Colors.deepPurple),
//             underline: Container(
//               height: 2,
//               color: Colors.deepPurpleAccent,
//             ),
//             onChanged: (_) {},
//             items: <String>['One', 'Two', 'Free', 'Four']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),

//home_filled

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
