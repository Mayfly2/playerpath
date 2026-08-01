import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── States ──
enum ThemeModeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeModeState> {
  static const _key = 'theme_mode';

  ThemeCubit() : super(ThemeModeState.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == 'dark') {
      emit(ThemeModeState.dark);
    } else if (stored == 'light') {
      emit(ThemeModeState.light);
    } else {
      emit(ThemeModeState.system);
    }
  }

  Future<void> setDarkMode(bool enabled) async {
    final mode = enabled ? ThemeModeState.dark : ThemeModeState.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, enabled ? 'dark' : 'light');
    emit(mode);
  }

  ThemeMode get themeMode {
    return switch (state) {
      ThemeModeState.dark => ThemeMode.dark,
      ThemeModeState.light => ThemeMode.light,
      ThemeModeState.system => ThemeMode.system,
    };
  }

  bool get isDark => state == ThemeModeState.dark;
}
