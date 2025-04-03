import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box<Character>('favorites');

    return ValueListenableBuilder(
      valueListenable: favoritesBox.listenable(),
      builder: (context, Box<Character> box, _) {
        final favorites = box.values.toList().cast<Character>()
          ..sort((a, b) => a.name.compareTo(b.name));

        if (favorites.isEmpty) {
          return const Center(child: Text("No favorites added"));
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final character = favorites[index];
            return CharacterCard(character: character);
          },
        );
      },
    );
  }
}
