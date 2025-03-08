import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Rick and Morty'),
      actions: [
        IconButton(
          onPressed: () {
            final adaptiveTheme = AdaptiveTheme.of(context);
            if (adaptiveTheme.mode.isDark) {
              adaptiveTheme.setLight();
            } else {
              adaptiveTheme.setDark();
            }
          },
          icon: Icon(
            AdaptiveTheme.of(context).mode.isDark
                ? Icons.wb_sunny
                : Icons.nightlight_round,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
