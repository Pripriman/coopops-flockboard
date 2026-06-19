import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'domain/flock_repository.dart';
import 'runtime/backend_link.dart';
import 'runtime/signal_relay.dart';
import 'runtime/trace_beacon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  try {
    await CoopLink.boot();
  } catch (_) {}

  await AlertRelay.boot();
  TallyBeacon.boot();

  final ledger = FlockRepository();
  await ledger.load();

  await _markFirstOpen();

  runApp(FlockBoardApp(ledger: ledger));
}

Future<void> _markFirstOpen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    const key = 'roost.first_open_sent';
    if (!(prefs.getBool(key) ?? false)) {
      TallyBeacon.firstOpen();
      await prefs.setBool(key, true);
    }
  } catch (_) {}
}
