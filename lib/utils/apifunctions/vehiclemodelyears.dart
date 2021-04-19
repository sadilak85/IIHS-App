import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

class ModelYears {
  Future<dynamic> getModelYears() async {
    const modelyears = '$v4ratings/modelyears';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsApiURL$modelyears?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    final modelyearsList =
        rawdata.findAllElements('year').map((e) => e.text).toList();
    return modelyearsList;
  }

  Future<dynamic> getModelYearsforMakeModelSeries(
      String make, String modelseries) async {
    const modelyears = '$v4ratings/modelyears-for-series';
    NetworkHelper networkHelper = NetworkHelper(
        '$iihsApiURL$modelyears/$make/$modelseries?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    final modelyearsList =
        rawdata.findAllElements('year').map((e) => e.text).toList();
    return modelyearsList;
  }
}
// final modelyearsList = rawdata
//     .findAllElements('make')
//     .where((category) => category.getAttribute('slug') == 'bmw')
//     .map((e) => e.text);

// final languages = node.findAllElements('Categories')
//         .where((category) => category.getAttribute('name') == 'Languages')
//         .expand((category) => category.findElements('Skill'))
//         .map((skill) => skill.text);
