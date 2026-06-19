import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'access/coop_access_screen.dart';
import 'home/coop_home_shell.dart';
import 'intro/onboarding_deck.dart';

enum _Stage { boot, intro, access, home }

class CoopRoot extends StatefulWidget {
  const CoopRoot({super.key});

  @override
  State<CoopRoot> createState() => _CoopRootState();
}

class _CoopRootState extends State<CoopRoot> {
  static const _introKey = 'roost.intro_done';
  _Stage _stage = _Stage.boot;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final prefs = await SharedPreferences.getInstance();
    final introDone = prefs.getBool(_introKey) ?? false;
    if (!mounted) return;
    setState(() => _stage = introDone ? _Stage.home : _Stage.intro);
  }

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introKey, true);
    if (!mounted) return;
    setState(() => _stage = _Stage.access);
  }

  void _finishAccess() => setState(() => _stage = _Stage.home);

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _Stage.boot:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case _Stage.intro:
        return OnboardingDeck(onDone: _finishIntro);
      case _Stage.access:
        return CoopAccessScreen(onDone: _finishAccess);
      case _Stage.home:
        return const CoopHomeShell();
    }
  }
}
