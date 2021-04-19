import 'package:xml/xml.dart' as xml;

import 'dart:developer';

Map<dynamic, dynamic> crashRatingsFrontalModerateOverlap(xmlData) {
  try {
    var frontalRatingsModerateOverlapValues = Map();
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

    frontalRatingsModerateOverlapValues['isPrimary'] = isPrimary;
    frontalRatingsModerateOverlapValues['isQualified'] = isQualified;
    frontalRatingsModerateOverlapValues['overallRating'] = overallRating;
    frontalRatingsModerateOverlapValues['headNeckRating'] = headNeckRating;
    frontalRatingsModerateOverlapValues['chestRating'] = chestRating;
    frontalRatingsModerateOverlapValues['femurPelvisRating'] = leftLegRating;
    frontalRatingsModerateOverlapValues['footTibiaRating'] = rightLegRating;
    frontalRatingsModerateOverlapValues['kinematicsRating'] = kinematicsRating;
    frontalRatingsModerateOverlapValues['structureRating'] = structureRating;
    frontalRatingsModerateOverlapValues['testSubject'] = testSubject;

    final photoelts = frontalRatingsModerateOverlap
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) frontalRatingsModerateOverlapValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) frontalRatingsModerateOverlapValues['photocaptions'] = photocaptions;

    final videoelts = frontalRatingsModerateOverlap
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoUrls.toString(),
    )) frontalRatingsModerateOverlapValues['videoUrls'] = videoUrls;

    final videtitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videtitles.toString(),
    )) frontalRatingsModerateOverlapValues['videtitles'] = videtitles;

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

    final photoelts = frontalRatingsSmallOverlap
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) frontalRatingsSmallOverlapValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) frontalRatingsSmallOverlapValues['photocaptions'] = photocaptions;

    final videoelts = frontalRatingsSmallOverlap
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoUrls.toString(),
    )) frontalRatingsSmallOverlapValues['videoUrls'] = videoUrls;
    final videtitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videtitles.toString(),
    )) frontalRatingsSmallOverlapValues['videtitles'] = videtitles;

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
        .expand((category) => category.findElements('passengerHeadNeckRating'))
        .map((skill) => skill.text);

    final driverChestRating = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('driverChestRating'))
        .map((skill) => skill.text);

    final passengerChestRating = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('passengerChestRating'))
        .map((skill) => skill.text);

    final driverFemurPelvisRating = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('driverFemurPelvisRating'))
        .map((skill) => skill.text);

    final passengerFemurPelvisRating = frontalRatingsSmallOverlapPassenger
        .expand(
            (category) => category.findElements('passengerFemurPelvisRating'))
        .map((skill) => skill.text);

    final driverFootTibiaRating = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('driverFootTibiaRating'))
        .map((skill) => skill.text);

    final passengerFootTibiaRating = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('passengerFootTibiaRating'))
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
    frontalRatingsSmallOverlapPassengerValues['overallRating'] = overallRating;
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

    final photoelts = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) frontalRatingsSmallOverlapPassengerValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    ))
      frontalRatingsSmallOverlapPassengerValues['photocaptions'] =
          photocaptions;

    final videoelts = frontalRatingsSmallOverlapPassenger
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoUrls.toString(),
    )) frontalRatingsSmallOverlapPassengerValues['videoUrls'] = videoUrls;
    final videtitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videtitles.toString(),
    )) frontalRatingsSmallOverlapPassengerValues['videtitles'] = videtitles;

    return frontalRatingsSmallOverlapPassengerValues;
  } catch (e) {
    print(e);
    return null;
  }
}

//
