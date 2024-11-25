import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'package:snap_fit/feature/theme/bloc/theme_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  final Size preferredSize = const Size(double.infinity, 40);

  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = context.watch<ThemeBloc>();

    Color activeColor = Theme.of(context).primaryColor;
    Color disabledColor = Theme.of(context).colorScheme.inversePrimary;
    return GestureDetector(
      onPanUpdate: (details) => windowManager.startDragging(),
      child: Container(
        padding: const EdgeInsets.only(left: 70, right: 0),
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.sunny),
              color: themeBloc.state.themeMode == ThemeMode.light ? activeColor : disabledColor,
              tooltip: 'Світла тема',
              onPressed: () {
                themeBloc.add(SetLightThemeEvent());
              },
            ),
            IconButton(
              icon: const Icon(Icons.nightlight),
              color: themeBloc.state.themeMode == ThemeMode.dark ? activeColor : disabledColor,
              tooltip: 'Темна тема',
              onPressed: () {
                themeBloc.add(SetDarkThemeEvent());
              },
            ),
            IconButton(
              icon: const Icon(Icons.sunny_snowing),
              color: themeBloc.state.themeMode == ThemeMode.system ? activeColor : disabledColor,
              tooltip: 'Тема як в системі',
              onPressed: () {
                themeBloc.add(SetSystemThemeEvent());
              },
            ),
            if (Platform.isWindows) ...[
              IconButton(
                icon: Icon(Icons.minimize),
                onPressed: windowManager.minimize,
              ),
              IconButton(
                icon: Icon(Icons.crop_square),
                onPressed: windowManager.maximize,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: windowManager.close,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
