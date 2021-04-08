import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

import 'dart:developer';

class CrashRatings {
  Future<dynamic> crashRatings(String year, String make, String series) async {
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

      final crashratingvalues = rawdata
          .findAllElements('frontalRatingsModerateOverlap')
          .expand((category) => category.findElements('rating'))
          .expand((category) => category.findElements('overallRating'))
          .map((skill) => skill.text);

      log(rawdata.toString());

      final vehicleclass =
          rawdata.findAllElements('class').map((e) => e.text).toString();

      final photoid = rawdata
          .findAllElements('photo')
          .map((e) => e.getAttribute('id'))
          .first
          .toString();

      String photoUrl = '$iihsURL/api/ratings/images/$photoid';

      return [crashratingvalues.toString(), vehicleclass, photoUrl];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
