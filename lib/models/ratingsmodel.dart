import 'package:iihs/helpers/networking.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

const iihsURL = 'https://api.iihs.org';
const apiKey = 'wWyy9pboIUa2zHyPhYPVKhjSHQoCDslFiNYlTF9VLSw';
const versionratings = '/V4/ratings';

class RatingsModel {
  getJsonFromXMLFile(content) {
    final Xml2Json xml2Json = Xml2Json();

    try {
      xml2Json.parse(content);
      var jsonString = xml2Json.toParker();
      return jsonDecode(jsonString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> testRatings() async {
    NetworkHelper networkHelper = NetworkHelper(
        'http://api.iihs.org/v4/ratings/single/2013/ford/edge?apikey=$apiKey');
    var xmlData = await networkHelper.getData();
    var rawdata = xml.XmlDocument.parse(xmlData);

    // final modelyearsList =
    //     rawdata.findAllElements('year').map((e) => e.text).toList();
    return rawdata;
  }

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
    // final modelyearsList = rawdata
    //     .findAllElements('make')
    //     .where((category) => category.getAttribute('slug') == 'bmw')
    //     .map((e) => e.text);

    return makeListonYear;
  }

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

  Future<dynamic> getALLMakes() async {
    const makes = '$versionratings/all-makes/';
    NetworkHelper networkHelper =
        NetworkHelper('$iihsURL$makes?apikey=$apiKey');
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

    var makeListALL = <Map>[];
    for (int i = 0; i <= makeNames.length - 1; i++) {
      var map = {};
      map['id'] = makeIds[i];
      map['slug'] = makeSlugs[i];
      map['name'] = makeNames[i];
      makeListALL.add(map);
    }
    return makeListALL;
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
