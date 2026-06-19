import 'package:flutter/material.dart';

import '../runtime/gate_router.dart';
import '../runtime/trace_beacon.dart';
import '../theme/barn_palette.dart';
import '../theme/barn_type.dart';
import '../widgets/feather_mark.dart';
import 'bad_connection_screen.dart';
import 'content/roost_monitor_view.dart';
import 'native_root.dart';

class CoopBootScreen extends StatefulWidget {
  const CoopBootScreen({super.key});

  @override
  State<CoopBootScreen> createState() => _CoopBootScreenState();
}

class _CoopBootScreenState extends State<CoopBootScreen>
    with SingleTickerProviderStateMixin {
  late Future<GateResult> _future;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _future = RoostGate.resolve();
  }

  void _retry() {
    setState(() {
      _future = RoostGate.resolve();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GateResult>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return _splash();
        }
        final result = snap.data ?? const GateResult(GateOutcome.native);
        switch (result.outcome) {
          case GateOutcome.badConnection:
            return OfflineCoopScreen(onRetry: _retry);
          case GateOutcome.content:
            TallyBeacon.contentOpen();
            return RoostMonitorView(endpoint: result.endpoint!);
          case GateOutcome.native:
            return const CoopRoot();
        }
      },
    );
  }

  Widget _splash() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BarnPalette.barnGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.06).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: const FeatherMark(size: 96, color: BarnPalette.barn),
              ),
              const SizedBox(height: 26),
              Text('Waking the coop…',
                  style: BarnType.heading(color: BarnPalette.barnDeep)),
            ],
          ),
        ),
      ),
    );
  }
}
