import 'package:xml/xml.dart' as xml;

//import 'dart:developer';

Map<dynamic, dynamic> crashRatingsRear(xmlData) {
  try {
    var rearRatingsValues = Map();
    final rearRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('rearRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary =
        rearRatings.map((e) => e.getAttribute('isPrimary')).toList();

    final isQualified =
        rearRatings.map((e) => e.getAttribute('isQualified')).toList();

    final overallRating = rearRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    final dynamicRating = rearRatings
        .expand((category) => category.findElements('dynamicRating'))
        .map((skill) => skill.text);

    final geometryRating = rearRatings
        .expand((category) => category.findElements('geometryRating'))
        .map((skill) => skill.text);

    final seatType = rearRatings
        .expand((category) => category.findElements('seatType'))
        .map((skill) => skill.text);

    final testSubject = rearRatings
        .expand((category) => category.findElements('testSubject'))
        .map((skill) => skill.text);

    rearRatingsValues['isPrimary'] = isPrimary;
    rearRatingsValues['isQualified'] = isQualified;
    rearRatingsValues['overallRating'] = overallRating;
    rearRatingsValues['dynamicRating'] = dynamicRating;
    rearRatingsValues['geometryRating'] = geometryRating;
    rearRatingsValues['seatType'] = seatType;
    rearRatingsValues['testSubject'] = testSubject;

    final photoelts = rearRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) rearRatingsValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) rearRatingsValues['photocaptions'] = photocaptions;

    final videoelts = rearRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoPlayerUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoPlayerUrls.toString(),
    )) rearRatingsValues['videoPlayerUrls'] = videoPlayerUrls;

    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    )) rearRatingsValues['videoDownloadUrls'] = videoDownloadUrls;

    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) rearRatingsValues['videotitles'] = videotitles;

    return rearRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
