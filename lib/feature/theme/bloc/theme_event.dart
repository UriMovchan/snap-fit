part of 'theme_bloc.dart';

abstract class ThemeEvent {}

final class SetDarkThemeEvent extends ThemeEvent {}

final class SetLightThemeEvent extends ThemeEvent {}

final class SetSystemThemeEvent extends ThemeEvent {}
