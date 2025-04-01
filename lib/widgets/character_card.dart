import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/widgets/fav_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterCard extends StatelessWidget {

  const CharacterCard({
    super.key,
    required this.character,
  });
  final Character character;

  @override
  Widget build(BuildContext context) => Card(
      key: ValueKey(character.id),
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image(
              width: 140,
              height: 140,
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(character.image),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    character.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: character.status == 'Alive'
                              ? greenColor
                              : character.status == 'Dead'
                              ? redColor
                              : greyColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${character.status} - ${character.species}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FavButton(character: character),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
