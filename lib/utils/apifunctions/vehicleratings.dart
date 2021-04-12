import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';
import 'package:iihs/models/vehicleData.dart';

import 'dart:developer';

class CrashRatings {
  Future<dynamic> crashRatingsImages(
      String year, String make, String series) async {
    const crashrating = '$versionratings/single/';
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();
      var rawdata = xml.XmlDocument.parse(xmlData);

      final photoids = rawdata.findAllElements('photo');
      String photoUrl;
      if (photoids.toString() != '()') {
        final photoid =
            photoids.map((e) => e.getAttribute('id')).first.toString();
        photoUrl = '$iihsURL/api/ratings/images/$photoid';
      } else {
        photoUrl = '?????';
      }
      return photoUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

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

  Map<dynamic, dynamic> crashRatingsFrontalModerateOverlap(xmlData) {
    try {
      final frontalRatingsModerateOverlap = xml.XmlDocument.parse(xmlData)
          .findAllElements('frontalRatingsModerateOverlap')
          .expand((category) => category.findElements('rating'));

      final isPrimary = frontalRatingsModerateOverlap
          .map((e) => e.getAttribute('isPrimary'))
          .toList();

      final isQualified = frontalRatingsModerateOverlap
          .map((e) => e.getAttribute('isQualified'))
          .toList();

      final overallRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);

      final headNeckRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('headNeckRating'))
          .map((skill) => skill.text);

      final chestRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('chestRating'))
          .map((skill) => skill.text);

      final leftLegRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('leftLegRating'))
          .map((skill) => skill.text);

      final rightLegRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('rightLegRating'))
          .map((skill) => skill.text);

      final kinematicsRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('kinematicsRating'))
          .map((skill) => skill.text);

      final structureRating = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('structureRating'))
          .map((skill) => skill.text);

      final testSubject = frontalRatingsModerateOverlap
          .expand((category) => category.findElements('testSubject'))
          .map((skill) => skill.text);

      var frontalRatingsModerateOverlapValues = Map();
      frontalRatingsModerateOverlapValues['isPrimary'] = isPrimary;
      frontalRatingsModerateOverlapValues['isQualified'] = isQualified;
      frontalRatingsModerateOverlapValues['overallRating'] = overallRating;
      frontalRatingsModerateOverlapValues['headNeckRating'] = headNeckRating;
      frontalRatingsModerateOverlapValues['chestRating'] = chestRating;
      frontalRatingsModerateOverlapValues['femurPelvisRating'] = leftLegRating;
      frontalRatingsModerateOverlapValues['footTibiaRating'] = rightLegRating;
      frontalRatingsModerateOverlapValues['kinematicsRating'] =
          kinematicsRating;
      frontalRatingsModerateOverlapValues['structureRating'] = structureRating;
      frontalRatingsModerateOverlapValues['testSubject'] = testSubject;

      return frontalRatingsModerateOverlapValues;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<dynamic, dynamic> crashRatingsFrontalSmallOverlap(xmlData) {
    try {
      final frontalRatingsSmallOverlap = xml.XmlDocument.parse(xmlData)
          .findAllElements('frontalRatingsSmallOverlap')
          .expand((category) => category.findElements('rating'));

      final isPrimary = frontalRatingsSmallOverlap
          .map((e) => e.getAttribute('isPrimary'))
          .toList();

      final isQualified = frontalRatingsSmallOverlap
          .map((e) => e.getAttribute('isQualified'))
          .toList();

      final overallRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);

      final headNeckRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('headNeckRating'))
          .map((skill) => skill.text);

      final chestRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('chestRating'))
          .map((skill) => skill.text);

      final femurPelvisRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('femurPelvisRating'))
          .map((skill) => skill.text);

      final footTibiaRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('footTibiaRating'))
          .map((skill) => skill.text);

      final kinematicsRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('kinematicsRating'))
          .map((skill) => skill.text);

      final structureRating = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('structureRating'))
          .map((skill) => skill.text);

      final testSubject = frontalRatingsSmallOverlap
          .expand((category) => category.findElements('testSubject'))
          .map((skill) => skill.text);

      var frontalRatingsSmallOverlapValues = Map();
      frontalRatingsSmallOverlapValues['isPrimary'] = isPrimary;
      frontalRatingsSmallOverlapValues['isQualified'] = isQualified;
      frontalRatingsSmallOverlapValues['overallRating'] = overallRating;
      frontalRatingsSmallOverlapValues['headNeckRating'] = headNeckRating;
      frontalRatingsSmallOverlapValues['chestRating'] = chestRating;
      frontalRatingsSmallOverlapValues['femurPelvisRating'] = femurPelvisRating;
      frontalRatingsSmallOverlapValues['footTibiaRating'] = footTibiaRating;
      frontalRatingsSmallOverlapValues['kinematicsRating'] = kinematicsRating;
      frontalRatingsSmallOverlapValues['structureRating'] = structureRating;
      frontalRatingsSmallOverlapValues['testSubject'] = testSubject;

      return frontalRatingsSmallOverlapValues;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<dynamic, dynamic> crashRatingsFrontalSmallOverlapPassenger(xmlData) {
    try {
      final frontalRatingsSmallOverlapPassenger = xml.XmlDocument.parse(xmlData)
          .findAllElements('frontalRatingsSmallOverlapPassenger')
          .expand((category) => category.findElements('rating'));

      final isPrimary = frontalRatingsSmallOverlapPassenger
          .map((e) => e.getAttribute('isPrimary'))
          .toList();

      final isQualified = frontalRatingsSmallOverlapPassenger
          .map((e) => e.getAttribute('isQualified'))
          .toList();

      final overallRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);

      final driverHeadNeckRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('driverHeadNeckRating'))
          .map((skill) => skill.text);

      final passengerHeadNeckRating = frontalRatingsSmallOverlapPassenger
          .expand(
              (category) => category.findElements('passengerHeadNeckRating'))
          .map((skill) => skill.text);

      final driverChestRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('driverChestRating'))
          .map((skill) => skill.text);

      final passengerChestRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('passengerChestRating'))
          .map((skill) => skill.text);

      final driverFemurPelvisRating = frontalRatingsSmallOverlapPassenger
          .expand(
              (category) => category.findElements('driverFemurPelvisRating'))
          .map((skill) => skill.text);

      final passengerFemurPelvisRating = frontalRatingsSmallOverlapPassenger
          .expand(
              (category) => category.findElements('passengerFemurPelvisRating'))
          .map((skill) => skill.text);

      final driverFootTibiaRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('driverFootTibiaRating'))
          .map((skill) => skill.text);

      final passengerFootTibiaRating = frontalRatingsSmallOverlapPassenger
          .expand(
              (category) => category.findElements('passengerFootTibiaRating'))
          .map((skill) => skill.text);

      final driverKinematicsRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('driverKinematicsRating'))
          .map((skill) => skill.text);

      final passengerKinematicsRating = frontalRatingsSmallOverlapPassenger
          .expand(
              (category) => category.findElements('passengerKinematicsRating'))
          .map((skill) => skill.text);

      final structureRating = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('structureRating'))
          .map((skill) => skill.text);

      final testSubject = frontalRatingsSmallOverlapPassenger
          .expand((category) => category.findElements('testSubject'))
          .map((skill) => skill.text);

      var frontalRatingsSmallOverlapPassengerValues = Map();
      frontalRatingsSmallOverlapPassengerValues['isPrimary'] = isPrimary;
      frontalRatingsSmallOverlapPassengerValues['isQualified'] = isQualified;
      frontalRatingsSmallOverlapPassengerValues['overallRating'] =
          overallRating;
      frontalRatingsSmallOverlapPassengerValues['driverHeadNeckRating'] =
          driverHeadNeckRating;
      frontalRatingsSmallOverlapPassengerValues['passengerHeadNeckRating'] =
          passengerHeadNeckRating;
      frontalRatingsSmallOverlapPassengerValues['driverChestRating'] =
          driverChestRating;
      frontalRatingsSmallOverlapPassengerValues['passengerChestRating'] =
          passengerChestRating;
      frontalRatingsSmallOverlapPassengerValues['driverFemurPelvisRating'] =
          driverFemurPelvisRating;
      frontalRatingsSmallOverlapPassengerValues['passengerFemurPelvisRating'] =
          passengerFemurPelvisRating;
      frontalRatingsSmallOverlapPassengerValues['driverFootTibiaRating'] =
          driverFootTibiaRating;
      frontalRatingsSmallOverlapPassengerValues['passengerFootTibiaRating'] =
          passengerFootTibiaRating;
      frontalRatingsSmallOverlapPassengerValues['driverKinematicsRating'] =
          driverKinematicsRating;
      frontalRatingsSmallOverlapPassengerValues['passengerKinematicsRating'] =
          passengerKinematicsRating;
      frontalRatingsSmallOverlapPassengerValues['structureRating'] =
          structureRating;
      frontalRatingsSmallOverlapPassengerValues['testSubject'] = testSubject;

      return frontalRatingsSmallOverlapPassengerValues;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //
}
