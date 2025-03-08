import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rick_and_morty/constants/colors.dart';
import 'package:rick_and_morty/api/models/character.dart';
import 'package:rick_and_morty/api/sqlite.dart';

class FavButton extends StatefulWidget {
  final Character character;
  final VoidCallback onFavoriteChanged;

  const FavButton({
    super.key,
    required this.character,
    required this.onFavoriteChanged,
  });

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.character.isFavorite;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (isFavorite) {
      _controller.value = 1.0;
    }
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _colorAnimation = ColorTween(
      begin: lightGreyColor,
      end: goldColor,
    ).animate(curvedAnimation);
  }

  void _toggleFavorite() async {
    if (!isFavorite) {
      await _controller.forward();
    } else {
      await _controller.reverse();
    }
    await DatabaseHelper.instance.toggleFavorite(widget.character.id);
    widget.character.toggleFavorite();
    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
      });
      widget.onFavoriteChanged();
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return IconButton(
          onPressed: _toggleFavorite,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(_controller.value * math.pi),
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(_colorAnimation.value),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );

  }
}
