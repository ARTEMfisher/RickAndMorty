import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/sqlite.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'widgets/characterCard.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Character> favoriteCharacters = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await DatabaseHelper.instance.getFavoriteCharacters();
    setState(() {
      favoriteCharacters = favorites;
    });
  }

  void _onFavoriteChanged() {
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: favoriteCharacters.length,
        itemBuilder: (context, index) {
          final character = favoriteCharacters[index];
          return CharacterCard(
            character: character,
            onFavoriteChanged: _onFavoriteChanged,
          );
        },
    );
  }
}
