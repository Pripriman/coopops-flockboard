import 'package:flutter/material.dart';
import 'barn_palette.dart';
import 'barn_type.dart';

class BarnTheme {
  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: BarnPalette.olive,
      primary: BarnPalette.olive,
      secondary: BarnPalette.barn,
      surface: BarnPalette.card,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BarnPalette.paper,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: BarnPalette.ink,
      ),
      cardTheme: CardThemeData(
        color: BarnPalette.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: BarnPalette.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BarnPalette.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: BarnType.body(color: BarnPalette.inkFaint),
        border: _inputBorder(BarnPalette.hairline),
        enabledBorder: _inputBorder(BarnPalette.hairline),
        focusedBorder: _inputBorder(BarnPalette.olive),
        errorBorder: _inputBorder(BarnPalette.critical),
        focusedErrorBorder: _inputBorder(BarnPalette.critical),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: BarnPalette.ink,
        contentTextStyle: BarnType.bodyStrong(color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: c, width: 1.4),
      );
}
