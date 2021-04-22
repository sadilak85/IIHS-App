import 'package:flutter/material.dart';
import 'package:iihs/models/constants/app_theme.dart';

ratingsOverviewTab(arg, context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.transparent,
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: arg.vehiclemainimage != null
                  ? Image.network(
                      arg.vehiclemainimage.toString(),
                      filterQuality: FilterQuality.low,
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
                    )
                  : Image.asset(
                      'assets/images/logo-iihs-in-app.png',
                      fit: BoxFit.scaleDown,
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            arg.modelyear + ' ' + arg.makename,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontWeight: FontWeight.w600,
              fontSize: 20,
              // letterSpacing: 0.27,
              color: AppTheme.darkerText,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Text(
            arg.seriesname,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontWeight: FontWeight.w600,
              fontSize: 18,
              // letterSpacing: 0.27,
              color: AppTheme.darkerText,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              arg.vehicleclass,
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),

        //
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 20),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Crashworthiness",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),
        //
        // Small overlap front: driver-side Ratings:
        if (arg.frontalRatingsSmallOverlapExists)
          if (arg.frontalRatingsSmallOverlap['overallRating']
              .toString()
              .contains("Good"))
            ratingIndicator('Small overlap front: driver-side', 'G'),
        if (arg.frontalRatingsSmallOverlap['overallRating']
            .toString()
            .contains("Acceptable"))
          ratingIndicator('Small overlap front: driver-side', 'A'),
        if (arg.frontalRatingsSmallOverlap['overallRating']
            .toString()
            .contains("Marginal"))
          ratingIndicator('Small overlap front: driver-side', 'M'),
        if (arg.frontalRatingsSmallOverlap['overallRating']
            .toString()
            .contains("Poor"))
          ratingIndicator('Small overlap front: driver-side', 'P'),
        // Small overlap front: passenger-side Ratings:
        if (arg.frontalRatingsSmallOverlapPassengerExists)
          if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
              .toString()
              .contains("Good"))
            ratingIndicator('Small overlap front: passenger-side', 'G'),
        if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
            .toString()
            .contains("Acceptable"))
          ratingIndicator('Small overlap front: passenger-side', 'A'),
        if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
            .toString()
            .contains("Marginal"))
          ratingIndicator('Small overlap front: passenger-side', 'M'),
        if (arg.frontalRatingsSmallOverlapPassenger['overallRating']
            .toString()
            .contains("Poor"))
          ratingIndicator('Small overlap front: passenger-side', 'P'),
        // Moderate overlap front Ratings:
        if (arg.frontalRatingsModerateOverlapExists)
          if (arg.frontalRatingsModerateOverlap['overallRating']
              .toString()
              .contains("Good"))
            ratingIndicator('Moderate overlap front', 'G'),
        if (arg.frontalRatingsModerateOverlap['overallRating']
            .toString()
            .contains("Acceptable"))
          ratingIndicator('Moderate overlap front', 'A'),
        if (arg.frontalRatingsModerateOverlap['overallRating']
            .toString()
            .contains("Marginal"))
          ratingIndicator('Moderate overlap front', 'M'),
        if (arg.frontalRatingsModerateOverlap['overallRating']
            .toString()
            .contains("Poor"))
          ratingIndicator('Moderate overlap front', 'P'),
        // Side Ratings:
        if (arg.sideRatingsExists)
          if (arg.sideRatings['overallRating'].toString().contains("Good"))
            ratingIndicator('Side', 'G'),
        if (arg.sideRatings['overallRating'].toString().contains("Acceptable"))
          ratingIndicator('Side', 'A'),
        if (arg.sideRatings['overallRating'].toString().contains("Marginal"))
          ratingIndicator('Side', 'M'),
        if (arg.sideRatings['overallRating'].toString().contains("Poor"))
          ratingIndicator('Side', 'P'),
        // Roof Strength Ratings:
        if (arg.rolloverRatingsExists)
          if (arg.rolloverRatings['overallRating'].toString().contains("Good"))
            ratingIndicator('Roof strength', 'G'),
        if (arg.rolloverRatings['overallRating']
            .toString()
            .contains("Acceptable"))
          ratingIndicator('Roof strength', 'A'),
        if (arg.rolloverRatings['overallRating']
            .toString()
            .contains("Marginal"))
          ratingIndicator('Roof strength', 'M'),
        if (arg.rolloverRatings['overallRating'].toString().contains("Poor"))
          ratingIndicator('Roof strength', 'P'),
        // Head restraints & seats Ratings
        if (arg.rearRatingsExists)
          if (arg.rearRatings['overallRating'].toString().contains("Good"))
            ratingIndicator('Head restraints & seats', 'G'),
        if (arg.rearRatings['overallRating'].toString().contains("Acceptable"))
          ratingIndicator('Head restraints & seats', 'A'),
        if (arg.rearRatings['overallRating'].toString().contains("Marginal"))
          ratingIndicator('Head restraints & seats', 'M'),
        if (arg.rearRatings['overallRating'].toString().contains("Poor"))
          ratingIndicator('Head restraints & seats', 'P'),
        //
        if (arg.headlightRatingsExists ||
            arg.frontCrashPreventionRatingsExists ||
            arg.pedestrianAvoidanceRatingsExists)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Crash avoidance & mitigation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
        // Headlights Ratings:
        if (arg.headlightRatingsExists)
          if (arg.headlightRatings['overallRating'].toString().contains("Good"))
            ratingIndicator('Headlights', 'G'),
        if (arg.headlightRatings['overallRating']
            .toString()
            .contains("Acceptable"))
          ratingIndicator('Headlights', 'A'),
        if (arg.headlightRatings['overallRating']
            .toString()
            .contains("Marginal"))
          ratingIndicator('Headlights', 'M'),
        if (arg.headlightRatings['overallRating'].toString().contains("Poor"))
          ratingIndicator('Headlights', 'P'),
        // Front crash prevention: vehicle-to-vehicle Ratings:
        if (arg.frontCrashPreventionRatingsExists)
          if (arg.frontCrashPreventionRatings['overallRating']
              .toString()
              .contains("Superior"))
            ratingIndicator(
                'Front crash prevention: \nvehicle-to-vehicle', 'Super'),
        if (arg.frontCrashPreventionRatings['overallRating']
            .toString()
            .contains("Advanced"))
          ratingIndicator(
              'Front crash prevention: \nvehicle-to-vehicle', 'Adv'),
        if (arg.frontCrashPreventionRatings['overallRating']
            .toString()
            .contains("Basic"))
          ratingIndicator(
              'Front crash prevention: \nvehicle-to-vehicle', 'Basic'),

        // Front crash prevention: vehicle-to-pedestrian Ratings:
        if (arg.pedestrianAvoidanceRatingsExists)
          if (arg.pedestrianAvoidanceRatings['overallRating']
              .toString()
              .contains("Superior"))
            ratingIndicator(
                'Front crash prevention: vehicle-to-pedestrian', 'Super'),
        if (arg.pedestrianAvoidanceRatings['overallRating']
            .toString()
            .contains("Advanced"))
          ratingIndicator(
              'Front crash prevention: vehicle-to-pedestrian', 'Adv'),
        if (arg.pedestrianAvoidanceRatings['overallRating']
            .toString()
            .contains("Basic"))
          ratingIndicator(
              'Front crash prevention: vehicle-to-pedestrian', 'Basic'),

        //
        // KEY VIEW:
        //
        Padding(
          padding: EdgeInsets.only(
            top: 18.0,

            left: 20,
            //right: 330,
            right: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Container(
            color: Colors.black,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Key",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 20,
                  right: 2,
                ),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          bottom: 12,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              color: AppTheme.iihsratingsgreen,
                              child: Center(
                                child: Text(
                                  'G',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Good',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              color: AppTheme.iihsratingsyellow,
                              child: Center(
                                child: Text(
                                  'A',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Acceptable',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              color: AppTheme.iihsratingsorange,
                              child: Center(
                                child: Text(
                                  'M',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Marginal',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 25,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              color: AppTheme.iihsratingsred,
                              child: Center(
                                child: Text(
                                  'P',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Poor',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 2,
                  right: 20,
                ),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          bottom: 12,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppTheme.iihsratingsgreen,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    color: AppTheme.iihsratingsgreen,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.iihsratingsgreen,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Superior',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppTheme.iihsratingskeygrey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    color: AppTheme.iihsratingsgreen,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.iihsratingsgreen,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Advanced',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 67,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppTheme.iihsratingskeygrey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        topRight: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3,
                                  ),
                                  child: Container(
                                    width: 30,
                                    height: 8,
                                    color: AppTheme.iihsratingskeygrey,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.iihsratingsgreen,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(3),
                                      bottomRight: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                child: Text(
                                  'Basic',
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget ratingIndicator(_text, _ind) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 50, right: 50),
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              _text,
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),
        if (_ind != 'Super' && _ind != 'Adv' && _ind != 'Basic')
          Container(
            width: 30,
            height: 30,
            color: _ind == 'G'
                ? AppTheme.iihsratingsgreen
                : _ind == 'A'
                    ? AppTheme.iihsratingsyellow
                    : _ind == 'M'
                        ? AppTheme.iihsratingsorange
                        : _ind == 'P'
                            ? AppTheme.iihsratingsred
                            : AppTheme.iihsratingsgreen,
            child: Center(
              child: Text(
                _ind,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
        if (_ind == 'Super')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.iihsratingsgreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  color: AppTheme.iihsratingsgreen,
                ),
              ),
              Container(
                width: 30,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.iihsratingsgreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        if (_ind == 'Adv')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.iihsratingskeygrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  color: AppTheme.iihsratingsgreen,
                ),
              ),
              Container(
                width: 30,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.iihsratingsgreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        if (_ind == 'Basic')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.iihsratingskeygrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: Container(
                  width: 30,
                  height: 8,
                  color: AppTheme.iihsratingskeygrey,
                ),
              ),
              Container(
                width: 30,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.iihsratingsgreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
