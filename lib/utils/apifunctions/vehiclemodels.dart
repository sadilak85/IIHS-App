import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

class VehicleModels {
  Future<dynamic> getModels(String make) async {
    const modelformake = '$versionratings/models-for-make/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsApiURL$modelformake$make?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> modelNames =
        rawdata.findAllElements("make").map((e) => e.text).toList();

    List<String> modelIds = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> modelSlugs = rawdata
        .findAllElements('make')
        .map((e) => e.getAttribute('slug'))
        .toList();

    var modelListformake = <Map>[];
    for (int i = 0; i <= modelNames.length - 1; i++) {
      var map = {};
      map['id'] = modelIds[i];
      map['slug'] = modelSlugs[i];
      map['name'] = modelNames[i];
      modelListformake.add(map);
    }
    return modelListformake;
  }
}
