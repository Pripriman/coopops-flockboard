import 'package:flutter/material.dart';
import '../theme/barn_palette.dart';

Color statusTint(String status) {
  switch (status) {
    case 'Normal':
    case 'Healthy':
    case 'Done':
      return BarnPalette.healthy;
    case 'Low':
    case 'Watch':
    case 'Due':
      return BarnPalette.watch;
    case 'High':
    case 'Critical':
    case 'Overdue':
      return BarnPalette.critical;
    default:
      return BarnPalette.inkSoft;
  }
}
