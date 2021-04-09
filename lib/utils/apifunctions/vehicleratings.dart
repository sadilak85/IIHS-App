import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

import 'dart:developer';

class CrashRatings {
  Future<dynamic> crashRatingsgetClass(
      String year, String make, String series) async {
    const crashrating = '$versionratings/single/';
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();
      var rawdata = xml.XmlDocument.parse(xmlData);
      log(rawdata.toString());
      final vehicleclass =
          rawdata.findAllElements('class').map((e) => e.text).toString();

      return vehicleclass;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> crashRatingsImages(
      String year, String make, String series) async {
    const crashrating = '$versionratings/single/';
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();
      var rawdata = xml.XmlDocument.parse(xmlData);

      // String crashratingvalues = rawdata
      //     .findElements('frontalRatingsModerateOverlap')
      //     .expand((category) => category.findElements('overallRating'))
      //     .map((rating) => rating.text)
      //     .toString();
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

  Future<dynamic> crashRatingsFrontal(
      String year, String make, String series) async {
    const crashrating = '$versionratings/single/';
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsApiURL$crashrating$year/$make/$series?apikey=$apiKey');
      var xmlData = await networkHelper.getData();
      var rawdata = xml.XmlDocument.parse(xmlData);

      final crashratingvalues = rawdata
          .findAllElements('frontalRatingsModerateOverlap')
          .expand((category) => category.findElements('rating'))
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);
      log(crashratingvalues.toString());

      final smalloverlaprating = rawdata
          .findAllElements('frontalRatingsSmallOverlap')
          .expand((category) => category.findElements('rating'))
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);
      log(smalloverlaprating.toString());

      return [crashratingvalues.toString(), smalloverlaprating.toString()];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
