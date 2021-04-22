import 'package:xml/xml.dart' as xml;

Map<dynamic, dynamic> crashRatingsSide(xmlData) {
  try {
    var sideRatingsValues = Map();
    final sideRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('sideRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary =
        sideRatings.map((e) => e.getAttribute('isPrimary')).toList();

    final isQualified =
        sideRatings.map((e) => e.getAttribute('isQualified')).toList();

    final sideAirbagConfiguration = sideRatings
        .expand((category) => category.findElements('sideAirbagConfiguration'))
        .map((skill) => skill.text);

    final sideAirbagDescription = sideRatings
        .expand((category) => category.findElements('sideAirbagDescription'))
        .map((skill) => skill.text);

    final overallRating = sideRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    final driverHeadProtectionRating = sideRatings
        .expand(
            (category) => category.findElements('driverHeadProtectionRating'))
        .map((skill) => skill.text);

    final driverHeadNeckRating = sideRatings
        .expand((category) => category.findElements('driverHeadNeckRating'))
        .map((skill) => skill.text);

    final driverTorsoRating = sideRatings
        .expand((category) => category.findElements('driverTorsoRating'))
        .map((skill) => skill.text);

    final driverPelvisLegRating = sideRatings
        .expand((category) => category.findElements('driverPelvisLegRating'))
        .map((skill) => skill.text);

    final passengerHeadProtectionRating = sideRatings
        .expand((category) =>
            category.findElements('passengerHeadProtectionRating'))
        .map((skill) => skill.text);

    final passengerHeadNeckRating = sideRatings
        .expand((category) => category.findElements('passengerHeadNeckRating'))
        .map((skill) => skill.text);

    final passengerTorsoRating = sideRatings
        .expand((category) => category.findElements('passengerTorsoRating'))
        .map((skill) => skill.text);

    final passengerPelvisLegRating = sideRatings
        .expand((category) => category.findElements('passengerPelvisLegRating'))
        .map((skill) => skill.text);

    final structureRating = sideRatings
        .expand((category) => category.findElements('structureRating'))
        .map((skill) => skill.text);

    final testSubject = sideRatings
        .expand((category) => category.findElements('testSubject'))
        .map((skill) => skill.text);

    sideRatingsValues['isPrimary'] = isPrimary;
    sideRatingsValues['isQualified'] = isQualified;
    sideRatingsValues['sideAirbagConfiguration'] = sideAirbagConfiguration;
    sideRatingsValues['sideAirbagDescription'] = sideAirbagDescription;
    sideRatingsValues['overallRating'] = overallRating;
    sideRatingsValues['driverHeadProtectionRating'] =
        driverHeadProtectionRating;
    sideRatingsValues['driverHeadNeckRating'] = driverHeadNeckRating;
    sideRatingsValues['driverTorsoRating'] = driverTorsoRating;
    sideRatingsValues['driverPelvisLegRating'] = driverPelvisLegRating;
    sideRatingsValues['passengerHeadProtectionRating'] =
        passengerHeadProtectionRating;
    sideRatingsValues['passengerHeadNeckRating'] = passengerHeadNeckRating;
    sideRatingsValues['passengerTorsoRating'] = passengerTorsoRating;
    sideRatingsValues['passengerPelvisLegRating'] = passengerPelvisLegRating;

    sideRatingsValues['structureRating'] = structureRating;
    sideRatingsValues['testSubject'] = testSubject;

    final photoelts = sideRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) sideRatingsValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) sideRatingsValues['photocaptions'] = photocaptions;

    final videoelts = sideRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoPlayerUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoPlayerUrls.toString(),
    )) sideRatingsValues['videoPlayerUrls'] = videoPlayerUrls;

    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    )) sideRatingsValues['videoDownloadUrls'] = videoDownloadUrls;

    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) sideRatingsValues['videotitles'] = videotitles;

    return sideRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
