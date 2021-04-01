import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    var _url = Uri.parse(url);
    http.Response response = await http.get(_url);

    try {
      if (response.statusCode == 200) {
        //var data = json.encode(response.body);

        return response.body;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
