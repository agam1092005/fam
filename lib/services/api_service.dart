import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage';

  static Future fetchGroups() async {
    print("refreshed");
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Decode the response as a list
      final List<dynamic> data = json.decode(response.body);

      // Map each JSON object to a CardGroupModel
      return data[0]['hc_groups'];
    } else {
      throw Exception('Failed to load card groups');
    }
  }

}
