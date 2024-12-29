import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage';

  static Future fetchGroups() async {
    log("refreshed");
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data[0]['hc_groups'];
    } else {
      throw Exception('Failed to load card groups');
    }
  }
}
