import 'package:flutter/material.dart';

import '../../domain/coop_data.dart';
import '../../domain/status_tint.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/coop_card.dart';
import '../../widgets/gauge_card.dart';

class SensorBoardView extends StatefulWidget {
  const SensorBoardView({super.key});

  @override
  State<SensorBoardView> createState() => _SensorBoardViewState();
}

class _SensorBoardViewState extends State<SensorBoardView> {
  late int _seed;

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().millisecondsSinceEpoch ~/ 60000;
  }

  void _refresh() {
    setState(() {
      _seed = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    });
  }

  IconData _icon(String id) {
    if (id.startsWith('temp') || id == 'brooder') return Icons.thermostat_rounded;
    if (id.startsWith('humid')) return Icons.water_drop_rounded;
    if (id == 'ammonia') return Icons.air_rounded;
    if (id == 'feeder') return Icons.grass_rounded;
    if (id == 'water') return Icons.opacity_rounded;
    return Icons.sensors_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final sensors = CoopData.sensors(_seed);
    final alerts = sensors.where((s) => !s.inRange).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        CoopCard(
          color: alerts.isEmpty
              ? BarnPalette.oliveWash
              : BarnPalette.barnWash,
          border: Border.all(
            color: alerts.isEmpty
                ? BarnPalette.olive.withValues(alpha: 0.4)
                : BarnPalette.barn.withValues(alpha: 0.4),
          ),
          child: Row(
            children: [
              Icon(
                alerts.isEmpty
                    ? Icons.verified_rounded
                    : Icons.warning_amber_rounded,
                color: alerts.isEmpty ? BarnPalette.oliveDeep : BarnPalette.barn,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alerts.isEmpty
                      ? 'All sensors nominal across the coops.'
                      : '${alerts.length} sensor(s) out of range: ${alerts.map((s) => s.label.split(' · ').first).join(', ')}.',
                  style: BarnType.bodyStrong(color: BarnPalette.ink),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                color: BarnPalette.inkSoft,
                onPressed: _refresh,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('Live readings', style: BarnType.label()),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.86,
          children: sensors.map((s) {
            return GaugeCard(
              label: s.label,
              reading: s.value.toString(),
              unit: s.unit,
              fraction: s.fraction,
              icon: _icon(s.id),
              tint: statusTint(s.status),
              status: s.status,
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        Text(
          'Sensor values are demonstration readings. Pair your hardware hub to stream live coop telemetry.',
          style: BarnType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
