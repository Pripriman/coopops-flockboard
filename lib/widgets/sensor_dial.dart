import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/barn_palette.dart';

class SensorDial extends StatelessWidget {
  final double size;
  final double progress;
  final Color color;
  final Color track;
  final double stroke;
  final Widget? child;

  const SensorDial({
    super.key,
    required this.size,
    required this.progress,
    this.color = BarnPalette.olive,
    this.track = BarnPalette.oliveWash,
    this.stroke = 12,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: progress.clamp(0, 1).toDouble(),
          color: color,
          track: track,
          stroke: stroke,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;
  final double stroke;

  _GaugePainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.stroke,
  });

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepAngle = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, trackPaint);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, _startAngle, _sweepAngle * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke;
}
