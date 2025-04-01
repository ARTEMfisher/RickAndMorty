import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/providers/character_provider.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) => Consumer<CharacterProvider>(
      builder: (BuildContext context, CharacterProvider provider, Widget? child) {
        final List<Character> favoriteCharacters = provider.characters
            .where((Character character) => character.isFavorite)
            .toList()
          ..sort((Character a, Character b) => a.name.compareTo(b.name));

        if (favoriteCharacters.isEmpty) {
          return const Center(
            child: Text('No favorites added'),
          );
        }

        return ListView.builder(
          itemCount: favoriteCharacters.length,
          itemBuilder: (BuildContext context, int index) {
            final Character character = favoriteCharacters[index];
            return CharacterCard(character: character);
          },
        );
      },
    );
}
