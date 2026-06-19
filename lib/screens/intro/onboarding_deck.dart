import 'package:flutter/material.dart';
import '../../theme/barn_palette.dart';
import '../../theme/barn_type.dart';
import '../../widgets/chunky_button.dart';

class _Panel {
  final IconData icon;
  final Color tint;
  final String title;
  final String body;
  const _Panel(this.icon, this.tint, this.title, this.body);
}

class OnboardingDeck extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingDeck({super.key, required this.onDone});

  @override
  State<OnboardingDeck> createState() => _OnboardingDeckState();
}

class _OnboardingDeckState extends State<OnboardingDeck> {
  final _controller = PageController();
  int _index = 0;

  static const _panels = [
    _Panel(Icons.groups_2_rounded, BarnPalette.olive, 'Know your flock',
        'Track every batch by breed, age and role — layers, broilers, breeders — so you always know what is in the coop and how it is performing.'),
    _Panel(Icons.egg_alt_rounded, BarnPalette.amber, 'Watch the yield',
        'Log eggs each day and the dashboard spots a drop early — before a quiet hen turns into lost income across the whole flock.'),
    _Panel(Icons.health_and_safety_rounded, BarnPalette.barn, 'Stay ahead of health',
        'Keep a vaccination calendar, note symptoms and flag quarantines, so nothing slips and the barn stays healthy.'),
    _Panel(Icons.sensors_rounded, BarnPalette.oliveDeep, 'Read the coop',
        'Bring temperature, humidity, feeder and water sensors onto one board, and keep feed and power costs under control.'),
  ];

  bool get _last => _index == _panels.length - 1;

  void _next() {
    if (_last) {
      widget.onDone();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BarnPalette.barnGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: AnimatedOpacity(
                    opacity: _last ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: GhostLink(
                      label: 'Skip',
                      onPressed: _last ? null : widget.onDone,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _panels.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final p = _panels[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: p.tint.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                  color: p.tint.withValues(alpha: 0.4),
                                  width: 1.5),
                            ),
                            child: Icon(p.icon, size: 64, color: p.tint),
                          ),
                          const SizedBox(height: 40),
                          Text(p.title,
                              style: BarnType.title(),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 14),
                          Text(p.body,
                              style: BarnType.body(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_panels.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? BarnPalette.olive : BarnPalette.hairline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
                child: ChunkyButton(
                  label: _last ? 'Open the dashboard' : 'Next',
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
