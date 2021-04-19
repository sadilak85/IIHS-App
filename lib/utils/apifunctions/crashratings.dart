import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/apifunctions/frontalratings.dart';
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';
import 'package:iihs/models/vehicleData.dart';

import 'dart:developer';

class CrashRatings {
  bool frontalRatingsModerateOverlapExists;
  Map<dynamic, dynamic> frontalRatingsModerateOverlap;
  bool frontalRatingsSmallOverlapExists;
  Map<dynamic, dynamic> frontalRatingsSmallOverlap;
  bool frontalRatingsSmallOverlapPassengerExists;
  Map<dynamic, dynamic> frontalRatingsSmallOverlapPassenger;
  String vehicleclass;

  Future<dynamic> crashRatingsData(VehicleData selectedvehicle) async {
    const crashrating = '$versionratings/single/';
    final year = selectedvehicle.modelyear;
    final make = selectedvehicle.makeslug;
    final series = selectedvehicle.seriesslug;
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();

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
