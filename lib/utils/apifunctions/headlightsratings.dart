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

    final testSubject = headlightRatings
        .expand((category) => category.findElements('testSubject'))
        .map((skill) => skill.text);

    headlightRatingsValues['isPrimary'] = isPrimary;
    headlightRatingsValues['isQualified'] = isQualified;

    headlightRatingsValues['overallRating'] = overallRating;

    headlightRatingsValues['testSubject'] = testSubject;

    final photoelts = headlightRatings
        .expand((category) => category.findElements('photos'))
        .expand((category) => category.findElements('photo'));

    final photoids = photoelts.map((e) => e.getAttribute('id'));
    if (!["", "()", null].contains(
      photoids.toString(),
    )) headlightRatingsValues['photoids'] = photoids;

    final photocaptions = photoelts
        .expand((category) => category.findElements('caption'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      photocaptions.toString(),
    )) headlightRatingsValues['photocaptions'] = photocaptions;

    final videoelts = headlightRatings
        .expand((category) => category.findElements('videos'))
        .expand((category) => category.findElements('video'));

    final videoUrls = videoelts
        .expand((category) => category.findElements('playerUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoUrls.toString(),
    )) headlightRatingsValues['videoUrls'] = videoUrls;

    final videoDownloadUrls = videoelts
        .expand((category) => category.findElements('downloadUrl'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videoDownloadUrls.toString(),
    )) headlightRatingsValues['videoDownloadUrls'] = videoDownloadUrls;

    final videotitles = videoelts
        .expand((category) => category.findElements('title'))
        .map((skill) => skill.text);

    if (!["", "()", null].contains(
      videotitles.toString(),
    )) headlightRatingsValues['videotitles'] = videotitles;

    return headlightRatingsValues;
  } catch (e) {
    print(e);
    return null;
  }
}
//
