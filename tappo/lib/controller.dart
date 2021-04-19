import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Controller {
  Future<List> fetchData(String url) async {
    final response = await http.get(url);
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  int max(List<Map<String, dynamic>> data, String field1, String field2) {
    int max = 0;
    for (int i = 0; i < data.length; i++) {
      int elem = int.parse(data[i][field1][field2]);
      if (elem > max) max = elem;
    }
    return max;
  }

  int min(List<Map<String, dynamic>> data, String field1, String field2) {
    int min = int.parse(data[0][field1][field2]);
    for (int i = 1; i < data.length; i++) {
      int elem = int.parse(data[i][field1][field2]);
      if (elem < min) min = elem;
    }
    return min;
  }

  int getTimestamp(List<Map<String, dynamic>> data) {
    return int.parse(data[0]["timestamp"]);
  }
}
