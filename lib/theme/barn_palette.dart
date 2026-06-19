import 'package:flutter/material.dart';

class BarnPalette {
  static const Color paper = Color(0xFFF6F1E7);
  static const Color paperDeep = Color(0xFFEBE3D2);
  static const Color hairline = Color(0xFFDDD2BC);
  static const Color card = Color(0xFFFFFDF8);

  static const Color ink = Color(0xFF2C2418);
  static const Color inkSoft = Color(0xFF6B5E4A);
  static const Color inkFaint = Color(0xFFA1937C);

  static const Color barn = Color(0xFFB23A2E);
  static const Color barnDeep = Color(0xFF8C2A20);
  static const Color barnWash = Color(0xFFF4DAD3);

  static const Color olive = Color(0xFF5E7032);
  static const Color oliveDeep = Color(0xFF435223);
  static const Color oliveWash = Color(0xFFE4E8CF);

  static const Color amber = Color(0xFFE0982E);
  static const Color amberWash = Color(0xFFFBEBCC);

  static const Color healthy = Color(0xFF5E8E3E);
  static const Color watch = Color(0xFFD9982B);
  static const Color critical = Color(0xFFC0463A);

  static const LinearGradient barnGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEDE3CF), Color(0xFFF8F3E9)],
  );
}
