import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/getCharacter.dart';
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/api/sqlite.dart';
import 'widgets/characterCard.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ApiGetCharecters apiService = ApiGetCharecters();
  List<Character> characters = [];
  String? nextPage;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchData();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !isLoading &&
        nextPage != null) {
      fetchData(url: nextPage!);
    }
  }

  Future<void> fetchData({String url = "https://rickandmortyapi.com/api/character/"}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final result = await apiService.fetchCharacters(url);
      List<Character> apiCharacters = result['characters'];
      nextPage = result['nextPage'];

      // Сохраняем полученных персонажей в БД и синхронизируем состояние isFavorite
      for (var character in apiCharacters) {
        // Если персонаж уже есть в БД, берем его статус
        final local = await DatabaseHelper.instance.getCharacterById(character.id);
        if (local != null) {
          character.isFavorite = local.isFavorite;
        }
        await DatabaseHelper.instance.insertCharacter(character);
      }
      setState(() {
        characters.addAll(apiCharacters);
      });
    } catch (e) {
      // Если произошла ошибка (например, нет интернета), пробуем загрузить из БД
      final allCharacters = await DatabaseHelper.instance.getAllCharacters();
      setState(() {
        characters = allCharacters;
      });
    }
    _refreshFavorites();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshFavorites() async {
    final favorites = await DatabaseHelper.instance.getFavoriteCharacters();
    setState(() {
      characters = characters.map((c) {
        c.isFavorite = favorites.any((f) => f.id == c.id);
        return c;
      }).toList();
    });
  }

  void _onFavoriteChanged() {
    setState(() {}); // Просто перерисовываем экран
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: characters.length + (nextPage != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == characters.length) {
          return Center(
            child: CircularProgressIndicator(color: greenColor),
          );
        }
        final character = characters[index];
        return CharacterCard(
          character: character,
          onFavoriteChanged: _onFavoriteChanged,
        );
      },
    );
  }
}
