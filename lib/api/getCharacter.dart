import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/character.dart';

class ApiGetCharecters {
  String baseUrl = "https://rickandmortyapi.com/api/character/";

  Future<Map<String, dynamic>> fetchCharacters(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Character> characters = (data['results'] as List)
          .map((item) => Character.fromJson(item))
          .toList();
      return {
        'characters': characters,
        'nextPage': data['info']['next']
      };
    } else {
      throw Exception("Failed to load characters");
    }
  }
}
