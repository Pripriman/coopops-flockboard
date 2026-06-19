import 'package:flutter/material.dart';
import '../theme/barn_palette.dart';
import '../theme/barn_type.dart';
import 'sensor_dial.dart';

class GaugeCard extends StatelessWidget {
  final String label;
  final String reading;
  final String unit;
  final double fraction;
  final IconData icon;
  final Color tint;
  final String status;

  const GaugeCard({
    super.key,
    required this.label,
    required this.reading,
    required this.unit,
    required this.fraction,
    required this.icon,
    required this.tint,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BarnPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BarnPalette.hairline),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2418).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: tint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label,
                    style: BarnType.label(color: BarnPalette.inkSoft),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: SensorDial(
              size: 92,
              progress: fraction,
              color: tint,
              track: BarnPalette.paperDeep,
              stroke: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(reading,
                      style: BarnType.readout(22, color: BarnPalette.ink)),
                  Text(unit, style: BarnType.caption()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: BarnType.label(color: tint)),
          ),
        ],
      ),
    );
  }
}
