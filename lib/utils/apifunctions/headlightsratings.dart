import 'package:xml/xml.dart' as xml;

Map<dynamic, dynamic> crashRatingsHeadlight(xmlData) {
  try {
    var headlightRatingsValues = Map();
    final headlightRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('headlightRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary =
        headlightRatings.map((e) => e.getAttribute('isPrimary')).toList();

    final isQualified =
        headlightRatings.map((e) => e.getAttribute('isQualified')).toList();

    final qualifyingText =
        headlightRatings.map((e) => e.getAttribute('qualifyingText')).toList();

    final overallRating = headlightRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    final highBeamAssist = headlightRatings
        .expand((category) => category.findElements('highBeamAssist'))
        .map((skill) => skill.text);

    final curveAdaptive = headlightRatings
        .expand((category) => category.findElements('curveAdaptive'))
        .map((skill) => skill.text);

    final sourceHighBeamDescription = headlightRatings
        .expand(
            (category) => category.findElements('sourceHighBeamDescription'))
        .map((skill) => skill.text);

    final sourceLowBeamDescription = headlightRatings
        .expand((category) => category.findElements('sourceLowBeamDescription'))
        .map((skill) => skill.text);

    final chartUrl = headlightRatings
        .expand((category) => category.findElements('chartUrl'))
        .map((skill) => skill.text);

    headlightRatingsValues['isPrimary'] = isPrimary;
    headlightRatingsValues['isQualified'] = isQualified;
    headlightRatingsValues['qualifyingText'] = qualifyingText;
    headlightRatingsValues['overallRating'] = overallRating;
    headlightRatingsValues['highBeamAssist'] = highBeamAssist;
    headlightRatingsValues['curveAdaptive'] = curveAdaptive;
    headlightRatingsValues['sourceHighBeamDescription'] =
        sourceHighBeamDescription;
    headlightRatingsValues['sourceLowBeamDescription'] =
        sourceLowBeamDescription;
    headlightRatingsValues['chartUrl'] = chartUrl;
    //
    final photoelts = headlightRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) headlightRatingsValues['photoids'] = photoids;
    //
    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) headlightRatingsValues['photocaptions'] = photocaptions;
    //
    final videoelts = headlightRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));
    final videoPlayerUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoPlayerUrls.toString(),
    )) headlightRatingsValues['videoPlayerUrls'] = videoPlayerUrls;
    //
    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    )) headlightRatingsValues['videoDownloadUrls'] = videoDownloadUrls;
    //
    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) headlightRatingsValues['videotitles'] = videotitles;
    //
    final trimLevels = headlightRatings
        .expand((category) => category.findElements('trimLevels'))
        .expand((category) => category.findElements('trim'));

    final trimLevelsDescription =
        trimLevels.map((e) => e.getAttribute('description'));
    if (!["", "()", null].contains(
      trimLevelsDescription.toString(),
    )) headlightRatingsValues['trimLevelsDescription'] = trimLevelsDescription;

    return headlightRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
