import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {

  ThemeCubit():super(ThemeMode.system);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeMode.values[json['theme']];
    } catch (_) {
      return ThemeMode.system; // fallback
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'theme': state.index,
    };
  }
}