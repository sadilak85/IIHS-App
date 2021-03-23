import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';
// import 'package:iihs/models/vehiclemakesData.dart';
// import 'dart:developer';

class VehicleMakes {
  Future<dynamic> getMakes(String year) async {
    const makes = '$versionratings/makes/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$makes$year?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> makeNames =
        rawdata.findAllElements("make").map((e) => e.text).toList();

    List<String> makeIds = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> makeSlugs = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('slug'))
        .toList();

    var makeListonYear = <Map>[];
    for (int i = 0; i <= makeNames.length - 1; i++) {
      var map = {};
      map['id'] = makeIds[i];
      map['slug'] = makeSlugs[i];
      map['name'] = makeNames[i];
      makeListonYear.add(map);
    }

    return makeListonYear;
  }

  Future<dynamic> getALLMakes() async {
    const makes = '$versionratings/all-makes/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$makes?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    // List<VehicleMakesData> vehiclemakesDataList = [];

    List<String> makeNames =
        rawdata.findAllElements("make").map((e) => e.text).toList();

    List<String> makeIds = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> makeSlugs = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('slug'))
        .toList();

    var makeListALL = <Map>[];
    for (int i = 0; i <= makeNames.length - 1; i++) {
      var map = {};
      map['id'] = makeIds[i];
      map['slug'] = makeSlugs[i];
      map['name'] = makeNames[i];
      makeListALL.add(map);
    }

    // for (int i = 0; i <= makeNames.length - 1; i++) {
    //   vehiclemakesDataList.add(
    //     VehicleMakesData(
    //       id: int.parse(makeIds[i]),
    //       slug: makeSlugs[i],
    //       name: makeNames[i],
    //     ),
    //   );
    // }
    return makeListALL;
  }
}
