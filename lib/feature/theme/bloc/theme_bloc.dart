import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snap_fit/service/storage.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(themeModes) : super(ThemeState(themeModes[Storage.get('theme_mode')] ?? ThemeMode.system)) {
    on<SetDarkThemeEvent>(_onSetDark);
    on<SetLightThemeEvent>(_onSetLight);
    on<SetSystemThemeEvent>(_onSetSystem);
  }

  _onSetDark(SetDarkThemeEvent event, Emitter<ThemeState> emit) {
    if (state.themeMode != ThemeMode.dark) {
      Storage.set('theme_mode', ThemeMode.dark.toString());

      emit(ThemeState(ThemeMode.dark));
    }
  }

  _onSetLight(SetLightThemeEvent event, Emitter<ThemeState> emit) {
    if (state.themeMode != ThemeMode.light) {
      Storage.set('theme_mode', ThemeMode.light.toString());

      emit(ThemeState(ThemeMode.light));
    }
  }

  _onSetSystem(SetSystemThemeEvent event, Emitter<ThemeState> emit) {
    if (state.themeMode != ThemeMode.system) {
      Storage.set('theme_mode', ThemeMode.system.toString());

      emit(ThemeState(ThemeMode.system));
    }
  }
}
