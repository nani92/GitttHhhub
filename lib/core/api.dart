import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  int statusCode;
  String body;
  ApiException(this.statusCode, this.body);
}

class Api {
  static const BASE_URL = 'https://api.github.com';
  static const TIMEOUT = Duration(seconds: 5);

  static Future<String> send(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28'
      },
    ).timeout(TIMEOUT);

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }

    return response.body;
  }

  static Future<Map<String, dynamic>> search(String phrase) async {
    final url = '$BASE_URL/search/repositories?q=$phrase';
    final response = await send(url);
    return jsonDecode(response);
  }

  static Future<List<dynamic>> getList(String url) async {
    final response = await send(url);
    return jsonDecode(response);
  }
}
