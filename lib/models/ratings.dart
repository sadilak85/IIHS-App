import 'package:xml/xml.dart' as xml;
import 'package:iihs/helpers/networking.dart';
import 'package:iihs/constants/apiauth.dart';

class CrashRatings {
  Future<dynamic> crashRatings(String year, String make, String series) async {
    const crashrating = '$versionratings/single/';
    try {
      NetworkHelper networkHelper = NetworkHelper(
          '$iihsURL$crashrating$year/$make/$series?apikey=$apiKey');
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

      return crashratingvalues;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
