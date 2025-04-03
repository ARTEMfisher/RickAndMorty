import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/get_character.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:hive/hive.dart';

class CharacterProvider extends ChangeNotifier {
  final ApiGetCharecters apiService = ApiGetCharecters();
  final List<Character> _characters = [];
  String? _nextPage = "https://rickandmortyapi.com/api/character/";
  bool _isLoading = false;
  final Box<Character> favoritesBox = Hive.box<Character>('favorites');

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get hasMore => _nextPage != null;

  Future<void> fetchCharacters() async {
    if (_isLoading || _nextPage == null) return;
    _isLoading = true;
    Future.delayed(Duration.zero, () => notifyListeners());

    try {
      final result = await apiService.fetchCharacters(_nextPage!);
      List<Character> fetchedCharacters = result['characters'];
      _nextPage = result['nextPage'];
      for (var character in fetchedCharacters) {
        if (favoritesBox.containsKey(character.id)) {
          character.isFavorite = true;
        }
      }
      _characters.addAll(fetchedCharacters);
    } catch (e) {}
    _isLoading = false;

    Future.delayed(Duration.zero, () => notifyListeners());
  }


  Future<void> refreshCharacters() async {
    _characters.clear();
    _nextPage = "https://rickandmortyapi.com/api/character/";
    notifyListeners();
    await fetchCharacters();
  }

  Future<void> toggleFavorite(Character character) async {
    final index = _characters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      final newFavorite = !_characters[index].isFavorite;
      _characters[index].isFavorite = newFavorite;
      if (newFavorite) {
        await favoritesBox.put(character.id, _characters[index]);
      } else {
        await favoritesBox.delete(character.id);
      }
      notifyListeners();
    }
  }
}
