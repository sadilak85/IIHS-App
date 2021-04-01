import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/networking.dart';
import 'package:iihs/models/constants/apiauth.dart';

class VehicleImages {
  Future<dynamic> getMainImage(String make, String series, String year) async {
    try {
      NetworkHelper networkHelper =
          NetworkHelper('$iihsURL/ratings/vehicle/$make/$series/$year');
      var xmlData = await networkHelper.getData();
      var rawdata = xml.XmlDocument.parse(xmlData);

      String rawurl = rawdata
          .findAllElements('meta')
          .where((category) => category.getAttribute('id') == 'ogimage')
          .map((e) => e.getAttribute('content'))
          .toString();

      String modifiedurl = rawurl.endsWith(')')
          ? rawurl.substring(0, rawurl.length - 1)
          : rawurl;

      String imageurl = modifiedurl.startsWith('(')
          ? modifiedurl.substring(1, modifiedurl.length)
          : modifiedurl;

      return imageurl.contains('model-year-images') ? imageurl : null;
    } catch (e) {
      print(e);
    }
  }
}
