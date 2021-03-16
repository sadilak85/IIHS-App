import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);

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
