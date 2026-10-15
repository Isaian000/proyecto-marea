import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_proyecto_marea/my_app.dart';

void main() {
  testWidgets('muestra el registro diario y navega al historial', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Hola, Elena'), findsOneWidget);
    expect(find.text('Guardar registro'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.schedule_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Historial'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Reunión larga'), findsOneWidget);
  });
}
