import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/widgets/favButton.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback onFavoriteChanged;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteChanged,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image(
              width: 140,
              height: 140,
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(widget.character.image),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: widget.character.status == 'Alive'
                              ? greenColor
                              : widget.character.status == 'Dead'
                              ? redColor
                              : greyColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.character.status} - ${widget.character.species}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FavButton(
                    character: widget.character,
                    onFavoriteChanged: widget.onFavoriteChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
