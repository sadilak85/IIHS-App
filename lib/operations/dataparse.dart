import 'package:xml2json/xml2json.dart';
import 'dart:convert';

getJsonFromXMLFile(content) {
  // not used , json format ?  or continue on xml?
  final Xml2Json xml2Json = Xml2Json();

  try {
    xml2Json.parse(content);
    var jsonString = xml2Json.toParker();
    return jsonDecode(jsonString);
  } catch (e) {
    print(e);
  }
}
