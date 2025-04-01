import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/api/models/character.dart';

class FavButton extends StatefulWidget {

  const FavButton({
    super.key,
    required this.character,
  });
  final Character character;

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.value = widget.character.isFavorite ? 1.0 : 0.0;
    final curvedAnimation =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _colorAnimation = ColorTween(
      begin: lightGreyColor,
      end: goldColor,
    ).animate(curvedAnimation);
  }

  Future<void> _toggleFavorite() async {
    final provider =
    Provider.of<CharacterProvider>(context, listen: false);
    if (!widget.character.isFavorite) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
    provider.toggleFavorite(widget.character);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => IconButton(
          onPressed: _toggleFavorite,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(_controller.value * math.pi),
            child: Icon(
              widget.character.isFavorite ? Icons.star : Icons.star_border,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.all(_colorAnimation.value),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
    );
}
