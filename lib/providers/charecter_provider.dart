import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../api/models/character.dart';
import '../api/sqlite.dart';

class CharacterProvider extends ChangeNotifier {
  List<Character> characters = [];
  List<Character> favorites = [];

  Future<void> fetchCharacters({String url = "https://rickandmortyapi.com/api/character/"}) async {
    try {
      final result = await DatabaseHelper.instance.getAllCharacters();
      characters = result;
      favorites = result.where((character) => character.isFavorite).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching characters: $e");
    }
  }

  Future<void> toggleFavorite(Character character) async {
    await DatabaseHelper.instance.toggleFavorite(character.id);
    character.toggleFavorite();

    characters = characters.map((c) => c.id == character.id ? character : c).toList();
    favorites = characters.where((c) => c.isFavorite).toList();

    notifyListeners();
  }
}
