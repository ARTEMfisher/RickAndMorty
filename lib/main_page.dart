import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/providers/character_provider.dart';
import 'package:rick_and_morty/widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      provider.fetchCharacters();
    });
    _scrollController.addListener(() {
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.fetchCharacters();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<CharacterProvider>(
      builder: (BuildContext context, CharacterProvider provider, Widget? child) => ListView.builder(
          controller: _scrollController,
          itemCount: provider.characters.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == provider.characters.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: greenColor),
                ),
              );
            }
            final character = provider.characters[index];
            return CharacterCard(character: character);
          },
        ),
    );
}
