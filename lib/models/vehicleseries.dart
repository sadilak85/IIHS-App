import 'package:xml/xml.dart' as xml;
import 'package:iihs/helpers/networking.dart';
import 'package:iihs/constants/apiauth.dart';

class VehicleSeries {
  Future<dynamic> getSeries(String year, String make) async {
    const series = '$versionratings/series/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$series$year/$make?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> seriesNames =
        rawdata.findAllElements("series").map((e) => e.text).toList();

    List<String> seriesIds = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> seriesVariantTypeIds = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('variantTypeId'))
        .toList();

    List<String> seriesSlugs = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('slug'))
        .toList();

    List<String> seriesUrl = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('iihsUrl'))
        .toList();

    var seriesListonYearMake = <Map>[];
    for (int i = 0; i <= seriesNames.length - 1; i++) {
      var map = {};
      map['id'] = seriesIds[i];
      map['variantTypeId'] = seriesVariantTypeIds[i];
      map['slug'] = seriesSlugs[i];
      map['iihsUrl'] = seriesUrl[i];
      map['name'] = seriesNames[i];
      seriesListonYearMake.add(map);
    }
    return seriesListonYearMake;
  }

  Future<dynamic> getALLSeries(String make) async {
    const series = '$versionratings/all-series/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$series$make?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    List<String> seriesNames =
        rawdata.findAllElements("series").map((e) => e.text).toList();

    List<String> seriesIds = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('id'))
        .toList();

    List<String> seriesVariantTypeIds = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('variantTypeId'))
        .toList();

    List<String> seriesSlugs = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('slug'))
        .toList();

    List<String> seriesUrl = rawdata
        .findAllElements('series')
        .map((e) => e.getAttribute('iihsUrl'))
        .toList();

    var seriesListALL = <Map>[];
    for (int i = 0; i <= seriesNames.length - 1; i++) {
      var map = {};
      map['id'] = seriesIds[i];
      map['variantTypeId'] = seriesVariantTypeIds[i];
      map['slug'] = seriesSlugs[i];
      map['iihsUrl'] = seriesUrl[i];
      map['name'] = seriesNames[i];
      seriesListALL.add(map);
    }
    return seriesListALL;
  }
}
