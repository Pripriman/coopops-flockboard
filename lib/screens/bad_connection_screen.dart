import 'package:flutter/material.dart';
import '../theme/barn_palette.dart';
import '../theme/barn_type.dart';
import '../widgets/chunky_button.dart';

class OfflineCoopScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const OfflineCoopScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BarnPalette.barnGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: BarnPalette.barnWash,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_off_rounded,
                      size: 38, color: BarnPalette.barn),
                ),
                const SizedBox(height: 24),
                Text('Coop is off the grid',
                    style: BarnType.title(), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  'We could not reach the farm hub. Check your connection and sync again.',
                  style: BarnType.body(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ChunkyButton(
                  label: 'Sync again',
                  icon: Icons.refresh_rounded,
                  expand: false,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
