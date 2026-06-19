import 'package:flutter/material.dart';
import '../theme/barn_palette.dart';

class FeatherMark extends StatelessWidget {
  final double size;
  final Color color;

  const FeatherMark({
    super.key,
    this.size = 48,
    this.color = BarnPalette.olive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _HenPainter(color)),
    );
  }
}

class _HenPainter extends CustomPainter {
  final Color color;
  _HenPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final body = Path();
    body.moveTo(w * 0.30, h * 0.78);
    body.cubicTo(w * 0.10, h * 0.74, w * 0.12, h * 0.46, w * 0.34, h * 0.42);
    body.cubicTo(w * 0.40, h * 0.24, w * 0.58, h * 0.20, w * 0.64, h * 0.34);
    body.cubicTo(w * 0.84, h * 0.34, w * 0.92, h * 0.56, w * 0.78, h * 0.72);
    body.lineTo(w * 0.84, h * 0.86);
    body.lineTo(w * 0.70, h * 0.84);
    body.lineTo(w * 0.66, h * 0.78);
    body.lineTo(w * 0.46, h * 0.80);
    body.lineTo(w * 0.42, h * 0.88);
    body.lineTo(w * 0.30, h * 0.86);
    body.close();
    canvas.drawPath(body, paint);

    final comb = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    final crest = Path();
    crest.moveTo(w * 0.56, h * 0.22);
    crest.lineTo(w * 0.60, h * 0.10);
    crest.lineTo(w * 0.66, h * 0.20);
    crest.lineTo(w * 0.72, h * 0.12);
    crest.lineTo(w * 0.74, h * 0.26);
    crest.close();
    canvas.drawPath(crest, comb);
  }

  @override
  bool shouldRepaint(covariant _HenPainter old) => old.color != color;
}
