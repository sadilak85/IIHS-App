import 'package:xml/xml.dart' as xml;
import 'package:iihs/utils/helpers/NetworkHelper.dart';
import 'package:iihs/models/constants/apiauth.dart';

class VehicleSeries {
  Future<dynamic> getSeries(String year, String make) async {
    const series = '$v4ratings/series/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsApiURL$series$year/$make?apikey=$apiKey');
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
    const series = '$v4ratings/all-series/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsApiURL$series$make?apikey=$apiKey');
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

  Future<dynamic> getSeriesforMakeModel(String make, String model) async {
    const seriesformakemodel = '$v4ratings/series-for-makemodel/';
    NetworkHelper networkHelper = NetworkHelper(
        '$iihsApiURL$seriesformakemodel$make/$model?apikey=$apiKey');
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

    var seriesListformakemodel = <Map>[];
    for (int i = 0; i <= seriesNames.length - 1; i++) {
      var map = {};
      map['id'] = seriesIds[i];
      map['variantTypeId'] = seriesVariantTypeIds[i];
      map['slug'] = seriesSlugs[i];
      map['iihsUrl'] = seriesUrl[i];
      map['name'] = seriesNames[i];
      seriesListformakemodel.add(map);
    }
    return seriesListformakemodel;
  }
}
