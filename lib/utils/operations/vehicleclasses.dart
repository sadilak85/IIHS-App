import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

class VehicleClasses {
  Future<dynamic> getClasses(String year) async {
    const classes = '$versionratings/classes/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$classes$year?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> classNames =
        rawdata.findAllElements("class").map((e) => e.text).toList();

    List<String> classIds = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> classSlugs = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('slug'))
        .toList();

    List<String> classUrl = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('iihsUrl'))
        .toList();

    var classListonYear = <Map>[];
    for (int i = 0; i <= classNames.length - 1; i++) {
      var map = {};
      map['id'] = classIds[i];
      map['slug'] = classSlugs[i];
      map['iihsUrl'] = classUrl[i];
      map['name'] = classNames[i];
      classListonYear.add(map);
    }
    return classListonYear;
  }

  Future<dynamic> getALLClasses() async {
    const classes = '$versionratings/all-classes/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$classes?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> classNames =
        rawdata.findAllElements("class").map((e) => e.text).toList();

    List<String> classIds = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> classSlugs = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('slug'))
        .toList();

    List<String> classUrl = rawdata
        .findAllElements('class')
        .map((e) => e.getAttribute('iihsUrl'))
        .toList();

    var classListALL = <Map>[];
    for (int i = 0; i <= classNames.length - 1; i++) {
      var map = {};
      map['id'] = classIds[i];
      map['slug'] = classSlugs[i];
      map['iihsUrl'] = classUrl[i];
      map['name'] = classNames[i];
      classListALL.add(map);
    }
    return classListALL;
  }
}
