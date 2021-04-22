import 'package:xml/xml.dart' as xml;

import 'dart:developer';

Map<dynamic, dynamic> crashRatingsfrontCrashPrevention(xmlData) {
  try {
    var frontCrashPreventionRatingsValues = Map();
    final frontCrashPreventionRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('frontCrashPreventionRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary = frontCrashPreventionRatings
        .map((e) => e.getAttribute('isPrimary'))
        .toList();

    final isQualified = frontCrashPreventionRatings
        .map((e) => e.getAttribute('isQualified'))
        .toList();

    final qualifyingText = frontCrashPreventionRatings
        .map((e) => e.getAttribute('qualifyingText'))
        .toList();

    final overallRating = frontCrashPreventionRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    log(overallRating.toString());

    final highBeamAssist = frontCrashPreventionRatings
        .expand((category) => category.findElements('highBeamAssist'))
        .map((skill) => skill.text);

    final curveAdaptive = frontCrashPreventionRatings
        .expand((category) => category.findElements('curveAdaptive'))
        .map((skill) => skill.text);

    final sourceHighBeamDescription = frontCrashPreventionRatings
        .expand(
            (category) => category.findElements('sourceHighBeamDescription'))
        .map((skill) => skill.text);

    final sourceLowBeamDescription = frontCrashPreventionRatings
        .expand((category) => category.findElements('sourceLowBeamDescription'))
        .map((skill) => skill.text);

    final chartUrl = frontCrashPreventionRatings
        .expand((category) => category.findElements('chartUrl'))
        .map((skill) => skill.text);

    frontCrashPreventionRatingsValues['isPrimary'] = isPrimary;
    frontCrashPreventionRatingsValues['isQualified'] = isQualified;
    frontCrashPreventionRatingsValues['qualifyingText'] = qualifyingText;
    frontCrashPreventionRatingsValues['overallRating'] = overallRating;
    frontCrashPreventionRatingsValues['highBeamAssist'] = highBeamAssist;
    frontCrashPreventionRatingsValues['curveAdaptive'] = curveAdaptive;
    frontCrashPreventionRatingsValues['sourceHighBeamDescription'] =
        sourceHighBeamDescription;
    frontCrashPreventionRatingsValues['sourceLowBeamDescription'] =
        sourceLowBeamDescription;
    frontCrashPreventionRatingsValues['chartUrl'] = chartUrl;
    //
    final photoelts = frontCrashPreventionRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) frontCrashPreventionRatingsValues['photoids'] = photoids;
    //
    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) frontCrashPreventionRatingsValues['photocaptions'] = photocaptions;
    //
    final videoelts = frontCrashPreventionRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));
    final videoPlayerUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoPlayerUrls.toString(),
    )) frontCrashPreventionRatingsValues['videoPlayerUrls'] = videoPlayerUrls;
    //
    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    ))
      frontCrashPreventionRatingsValues['videoDownloadUrls'] =
          videoDownloadUrls;
    //
    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) frontCrashPreventionRatingsValues['videotitles'] = videotitles;
    //
    final trimLevels = frontCrashPreventionRatings
        .expand((category) => category.findElements('trimLevels'))
        .expand((category) => category.findElements('trim'));

    final trimLevelsDescription =
        trimLevels.map((e) => e.getAttribute('description'));
    if (!["", "()", null].contains(
      trimLevelsDescription.toString(),
    ))
      frontCrashPreventionRatingsValues['trimLevelsDescription'] =
          trimLevelsDescription;

    return frontCrashPreventionRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
