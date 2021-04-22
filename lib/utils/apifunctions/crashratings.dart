import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/apifunctions/crashRatingsFrontal.dart';
import 'package:iihs/utils/apifunctions/crashRatingsSide.dart';
import 'package:iihs/utils/apifunctions/crashRatingsRollover.dart';
import 'package:iihs/utils/apifunctions/crashRatingsRear.dart';
import 'package:iihs/utils/apifunctions/crashRatingsHeadlight.dart';
import 'package:iihs/utils/apifunctions/crashRatingsfrontCrashPrevention.dart';
import 'package:iihs/utils/apifunctions/crashRatingspedestrianAvoidance.dart';
import 'package:iihs/utils/helpers/NetworkHelper.dart';
import 'package:iihs/models/constants/apiauth.dart';
import 'package:iihs/models/vehicleData.dart';

// import 'dart:developer';

class CrashRatings {
  String vehicleclass;
  bool frontalRatingsModerateOverlapExists;
  Map<dynamic, dynamic> frontalRatingsModerateOverlap;
  bool frontalRatingsSmallOverlapExists;
  Map<dynamic, dynamic> frontalRatingsSmallOverlap;
  bool frontalRatingsSmallOverlapPassengerExists;
  Map<dynamic, dynamic> frontalRatingsSmallOverlapPassenger;
  bool rolloverRatingsExists;
  Map<dynamic, dynamic> rolloverRatings;
  bool sideRatingsExists;
  Map<dynamic, dynamic> sideRatings;
  bool rearRatingsExists;
  Map<dynamic, dynamic> rearRatings;
  bool headlightRatingsExists;
  Map<dynamic, dynamic> headlightRatings;
  bool frontCrashPreventionRatingsExists;
  Map<dynamic, dynamic> frontCrashPreventionRatings;
  bool pedestrianAvoidanceRatingsExists;
  Map<dynamic, dynamic> pedestrianAvoidanceRatings;

  Future<dynamic> crashRatingsData(VehicleData selectedvehicle) async {
    const crashrating = '$v4ratings/single/';
    final year = selectedvehicle.modelyear;
    final make = selectedvehicle.makeslug;
    final series = selectedvehicle.seriesslug;
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();

      //log(xmlData.toString());

      selectedvehicle.vehicleclass = crashRatingsgetClass(xmlData);

      Map<dynamic, dynamic> frontalRatingsModerateOverlapValues =
          crashRatingsFrontalModerateOverlap(xmlData);
      selectedvehicle.frontalRatingsModerateOverlap =
          frontalRatingsModerateOverlapValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('frontalRatingsModerateOverlap')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.frontalRatingsModerateOverlapExists = false
          : selectedvehicle.frontalRatingsModerateOverlapExists = true;
      //
      Map<dynamic, dynamic> frontalRatingsSmallOverlapValues =
          crashRatingsFrontalSmallOverlap(xmlData);
      selectedvehicle.frontalRatingsSmallOverlap =
          frontalRatingsSmallOverlapValues;

      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('frontalRatingsSmallOverlap')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.frontalRatingsSmallOverlapExists = false
          : selectedvehicle.frontalRatingsSmallOverlapExists = true;
      //
      Map<dynamic, dynamic> frontalRatingsSmallOverlapPassengerValues =
          crashRatingsFrontalSmallOverlapPassenger(xmlData);
      selectedvehicle.frontalRatingsSmallOverlapPassenger =
          frontalRatingsSmallOverlapPassengerValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('frontalRatingsSmallOverlapPassenger')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.frontalRatingsSmallOverlapPassengerExists = false
          : selectedvehicle.frontalRatingsSmallOverlapPassengerExists = true;
      //
      Map<dynamic, dynamic> rolloverRatingsValues =
          crashRatingsRollover(xmlData);
      selectedvehicle.rolloverRatings = rolloverRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('rolloverRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.rolloverRatingsExists = false
          : selectedvehicle.rolloverRatingsExists = true;
      //
      Map<dynamic, dynamic> sideRatingsValues = crashRatingsSide(xmlData);
      selectedvehicle.sideRatings = sideRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('sideRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.sideRatingsExists = false
          : selectedvehicle.sideRatingsExists = true;
      //
      Map<dynamic, dynamic> rearRatingsValues = crashRatingsRear(xmlData);
      selectedvehicle.rearRatings = rearRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('rearRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.rearRatingsExists = false
          : selectedvehicle.rearRatingsExists = true;
      //
      Map<dynamic, dynamic> headlightRatingsValues =
          crashRatingsHeadlight(xmlData);
      selectedvehicle.headlightRatings = headlightRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('headlightRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.headlightRatingsExists = false
          : selectedvehicle.headlightRatingsExists = true;
      //
      Map<dynamic, dynamic> frontCrashPreventionRatingsValues =
          crashRatingsfrontCrashPrevention(xmlData);
      selectedvehicle.frontCrashPreventionRatings =
          frontCrashPreventionRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('frontCrashPreventionRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.frontCrashPreventionRatingsExists = false
          : selectedvehicle.frontCrashPreventionRatingsExists = true;
      //
      //
      Map<dynamic, dynamic> pedestrianAvoidanceRatingsValues =
          crashRatingspedestrianAvoidance(xmlData);
      selectedvehicle.pedestrianAvoidanceRatings =
          pedestrianAvoidanceRatingsValues;
      (["", "()", null].contains(xml.XmlDocument.parse(xmlData)
              .findAllElements('pedestrianAvoidanceRatings')
              .map((e) => e.text)
              .toString()))
          ? selectedvehicle.pedestrianAvoidanceRatingsExists = false
          : selectedvehicle.pedestrianAvoidanceRatingsExists = true;
      //
      //
      //
      return selectedvehicle;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String crashRatingsgetClass(xmlData) {
    try {
      final vehicleclass = xml.XmlDocument.parse(xmlData)
          .findAllElements('class')
          .map((e) => e.text)
          .toString();

      return vehicleclass;
    } catch (e) {
      print(e);
      return null;
    }
  }
  //
}
