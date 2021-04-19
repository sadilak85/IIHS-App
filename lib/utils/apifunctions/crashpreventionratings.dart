import 'package:xml/xml.dart' as xml;

import 'dart:developer';

Map<dynamic, dynamic> crashRatingsSide(xmlData) {
  try {
    var sideRatingsValues = Map();
    final sideRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('sideRatings')
        .expand((category) => category.findElements('rating'));

    return sideRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
