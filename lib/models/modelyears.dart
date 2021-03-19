import 'package:xml/xml.dart' as xml;
import 'package:iihs/helpers/networking.dart';
import 'package:iihs/constants/apiauth.dart';

class ModelYears {
  Future<dynamic> getModelYears() async {
    const modelyears = '$versionratings/modelyears';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$modelyears?apikey=$apiKey');
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
