import 'package:flutter/material.dart';
import 'barn_palette.dart';

class BarnType {
  static TextStyle _t(
    FontWeight weight,
    double size, {
    double? height,
    double? spacing,
    Color? color,
  }) {
    return TextStyle(
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      color: color ?? BarnPalette.ink,
    );
  }

  static TextStyle display({Color? color}) =>
      _t(FontWeight.w800, 29, height: 1.1, spacing: -0.4, color: color);
  static TextStyle title({Color? color}) =>
      _t(FontWeight.w700, 22, height: 1.18, spacing: -0.2, color: color);
  static TextStyle heading({Color? color}) =>
      _t(FontWeight.w700, 17, height: 1.22, color: color);
  static TextStyle body({Color? color}) =>
      _t(FontWeight.w400, 15, height: 1.45, color: color ?? BarnPalette.inkSoft);
  static TextStyle bodyStrong({Color? color}) =>
      _t(FontWeight.w600, 15, height: 1.45, color: color);
  static TextStyle label({Color? color}) =>
      _t(FontWeight.w700, 12.5, spacing: 0.7, color: color);
  static TextStyle caption({Color? color}) =>
      _t(FontWeight.w600, 12, spacing: 0.2, color: color ?? BarnPalette.inkFaint);
  static TextStyle readout(double size, {Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: weight ?? FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: 0.4,
        color: color ?? BarnPalette.ink,
      );
  static TextStyle stamp(double size, {Color? color, double spacing = 2.4}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: spacing,
        color: color ?? BarnPalette.ink,
      );
}
