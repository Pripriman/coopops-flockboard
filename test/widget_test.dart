import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flockboard/domain/breed_catalog.dart';
import 'package:flockboard/widgets/feather_mark.dart';

void main() {
  testWidgets('FeatherMark renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: FeatherMark(size: 80)),
        ),
      ),
    );
    expect(find.byType(FeatherMark), findsOneWidget);
  });

  test('breed catalog covers common breeds', () {
    expect(BreedCatalog.byId('isabrown').purpose, 'Layer');
    expect(BreedCatalog.byId('rir').origin, 'United States');
    expect(BreedCatalog.byId('ameraucana').eggColor, 'Blue');
  });
}
