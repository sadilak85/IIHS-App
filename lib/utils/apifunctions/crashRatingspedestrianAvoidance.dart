import 'package:xml/xml.dart' as xml;

Map<dynamic, dynamic> crashRatingspedestrianAvoidance(xmlData) {
  try {
    var pedestrianAvoidanceRatingsValues = Map();
    final pedestrianAvoidanceRatings = xml.XmlDocument.parse(xmlData)
        .findAllElements('pedestrianAvoidanceRatings')
        .expand((category) => category.findElements('rating'));

    final isPrimary = pedestrianAvoidanceRatings
        .map((e) => e.getAttribute('isPrimary'))
        .toList();

    final isQualified = pedestrianAvoidanceRatings
        .map((e) => e.getAttribute('isQualified'))
        .toList();

    final qualifyingText = pedestrianAvoidanceRatings
        .map((e) => e.getAttribute('qualifyingText'))
        .toList();

    final overallRating = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('overallRating'))
        .map((skill) => skill.text);

    final highBeamAssist = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('highBeamAssist'))
        .map((skill) => skill.text);

    final curveAdaptive = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('curveAdaptive'))
        .map((skill) => skill.text);

    final sourceHighBeamDescription = pedestrianAvoidanceRatings
        .expand(
            (category) => category.findElements('sourceHighBeamDescription'))
        .map((skill) => skill.text);

    final sourceLowBeamDescription = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('sourceLowBeamDescription'))
        .map((skill) => skill.text);

    final chartUrl = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('chartUrl'))
        .map((skill) => skill.text);

    pedestrianAvoidanceRatingsValues['isPrimary'] = isPrimary;
    pedestrianAvoidanceRatingsValues['isQualified'] = isQualified;
    pedestrianAvoidanceRatingsValues['qualifyingText'] = qualifyingText;
    pedestrianAvoidanceRatingsValues['overallRating'] = overallRating;
    pedestrianAvoidanceRatingsValues['highBeamAssist'] = highBeamAssist;
    pedestrianAvoidanceRatingsValues['curveAdaptive'] = curveAdaptive;
    pedestrianAvoidanceRatingsValues['sourceHighBeamDescription'] =
        sourceHighBeamDescription;
    pedestrianAvoidanceRatingsValues['sourceLowBeamDescription'] =
        sourceLowBeamDescription;
    pedestrianAvoidanceRatingsValues['chartUrl'] = chartUrl;
    //
    final photoelts = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) pedestrianAvoidanceRatingsValues['photoids'] = photoids;
    //
    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) pedestrianAvoidanceRatingsValues['photocaptions'] = photocaptions;
    //
    final videoelts = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));
    final videoPlayerUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoPlayerUrls.toString(),
    )) pedestrianAvoidanceRatingsValues['videoPlayerUrls'] = videoPlayerUrls;
    //
    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    ))
      pedestrianAvoidanceRatingsValues['videoDownloadUrls'] = videoDownloadUrls;
    //
    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) pedestrianAvoidanceRatingsValues['videotitles'] = videotitles;
    //
    final trimLevels = pedestrianAvoidanceRatings
        .expand((category) => category.findElements('trimLevels'))
        .expand((category) => category.findElements('trim'));

    final trimLevelsDescription =
        trimLevels.map((e) => e.getAttribute('description'));
    if (!["", "()", null].contains(
      trimLevelsDescription.toString(),
    ))
      pedestrianAvoidanceRatingsValues['trimLevelsDescription'] =
          trimLevelsDescription;

    return pedestrianAvoidanceRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
