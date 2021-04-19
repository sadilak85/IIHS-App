import 'package:xml/xml.dart' as xml;

import 'dart:developer';

Map<dynamic, dynamic> crashRatingsRollover(xmlData) {
  try {
    var rolloverRatingsValues = Map();
    final rolloverRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('rolloverRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary =
        rolloverRatings.map((e) => e.getAttribute('isPrimary')).toList();

    final isQualified =
        rolloverRatings.map((e) => e.getAttribute('isQualified')).toList();

    final builtAfter = rolloverRatings
        .expand((category) => category.findElements('builtAfter'));

    final overallRating = rolloverRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    final force = rolloverRatings
        .expand((category) => category.findElements('force'))
        .map((skill) => skill.text);

    final weight = rolloverRatings
        .expand((category) => category.findElements('weight'))
        .map((skill) => skill.text);

    final ratio = rolloverRatings
        .expand((category) => category.findElements('ratio'))
        .map((skill) => skill.text);

    final testSubject = rolloverRatings
        .expand((category) => category.findElements('testSubject'))
        .map((skill) => skill.text);

    rolloverRatingsValues['isPrimary'] = isPrimary;
    rolloverRatingsValues['isQualified'] = isQualified;
    rolloverRatingsValues['overallRating'] = overallRating;
    rolloverRatingsValues['force'] = force;
    rolloverRatingsValues['weight'] = weight;
    rolloverRatingsValues['ratio'] = ratio;
    rolloverRatingsValues['testSubject'] = testSubject;

    final month = builtAfter.map((e) => e.getAttribute('month'));

    if (!["", "()", null].contains(
      month.toString(),
    )) rolloverRatingsValues['month'] = month;
    final year = builtAfter.map((e) => e.getAttribute('year'));
    if (!["", "()", null].contains(
      year.toString(),
    )) rolloverRatingsValues['year'] = year;

    final photoelts = rolloverRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) rolloverRatingsValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) rolloverRatingsValues['photocaptions'] = photocaptions;

    final videoelts = rolloverRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoUrls.toString(),
    )) rolloverRatingsValues['videoUrls'] = videoUrls;

    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    )) rolloverRatingsValues['videoDownloadUrls'] = videoDownloadUrls;

    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) rolloverRatingsValues['videotitles'] = videotitles;

    return rolloverRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
