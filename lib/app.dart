import 'package:flutter/material.dart';

import 'domain/flock_repository.dart';
import 'screens/coop_boot_screen.dart';
import 'state/coop_scope.dart';
import 'theme/barn_theme.dart';

class FlockBoardApp extends StatelessWidget {
  final FlockRepository ledger;
  const FlockBoardApp({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    return CoopScope(
      ledger: ledger,
      child: MaterialApp(
        title: 'Chicken Control',
        debugShowCheckedModeBanner: false,
        theme: BarnTheme.build(),
        home: const CoopBootScreen(),
      ),
    );
  }
}
