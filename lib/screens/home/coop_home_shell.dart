import 'package:flutter/material.dart';

import '../../runtime/backend_link.dart';
import '../../runtime/signal_relay.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../access/coop_access_screen.dart';
import 'flock_tally_view.dart';
import 'yield_log_view.dart';
import 'health_board_view.dart';
import 'cost_tracker_view.dart';
import 'sensor_board_view.dart';

class CoopHomeShell extends StatefulWidget {
  const CoopHomeShell({super.key});

  @override
  State<CoopHomeShell> createState() => _CoopHomeShellState();
}

class _CoopHomeShellState extends State<CoopHomeShell> {
  int _tab = 0;

  static const _titles = [
    'Flock tally',
    'Egg yield',
    'Health board',
    'Cost tracker',
    'Coop sensors',
  ];

  void _openAccount() {
    final signedIn = CoopLink.signedIn;
    showModalBottomSheet(
      context: context,
      backgroundColor: BarnPalette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keeper account', style: BarnType.heading()),
                const SizedBox(height: 6),
                Text(
                  signedIn
                      ? (CoopLink.currentUser?.email ?? 'Signed in')
                      : 'You are keeping records as a guest.',
                  style: BarnType.body(),
                ),
                const SizedBox(height: 16),
                if (signedIn)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout_rounded,
                        color: BarnPalette.barnDeep),
                    title: Text('Sign out',
                        style: BarnType.bodyStrong(
                            color: BarnPalette.barnDeep)),
                    onTap: () async {
                      await AlertRelay.unbindKeeper();
                      await CoopLink.signOut();
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                      if (mounted) setState(() {});
                    },
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login_rounded,
                        color: BarnPalette.olive),
                    title: Text('Sign in or create account',
                        style:
                            BarnType.bodyStrong(color: BarnPalette.olive)),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CoopAccessScreen(
                            onDone: () {
                              Navigator.of(context).maybePop();
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (_tab) {
      case 0:
        body = const FlockTallyView();
        break;
      case 1:
        body = const YieldLogView();
        break;
      case 2:
        body = const HealthBoardView();
        break;
      case 3:
        body = const CostTrackerView();
        break;
      case 4:
        body = const SensorBoardView();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: BarnPalette.paper,
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(_titles[_tab], style: BarnType.title()),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            color: BarnPalette.ink,
            onPressed: _openAccount,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: body,
      bottomNavigationBar: _BottomBar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomBar({required this.index, required this.onChanged});

  static const _items = [
    (Icons.groups_2_rounded, 'Flock'),
    (Icons.egg_alt_rounded, 'Yield'),
    (Icons.health_and_safety_rounded, 'Health'),
    (Icons.payments_rounded, 'Cost'),
    (Icons.sensors_rounded, 'Sensors'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BarnPalette.card,
        border: Border(top: BorderSide(color: BarnPalette.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == index;
              final item = _items[i];
              return Expanded(
                child: InkResponse(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$1,
                        size: 23,
                        color: selected
                            ? BarnPalette.olive
                            : BarnPalette.inkFaint,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        style: BarnType.caption(
                          color: selected
                              ? BarnPalette.olive
                              : BarnPalette.inkFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
