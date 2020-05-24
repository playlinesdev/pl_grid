import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pl_grid/pl_grid.dart';

PlGrid get _baseWidget => PlGrid(
      curPage: 1,
      maxPages: 10,
      headerColumns: ['Id', 'Name', 'Age'],
      data: [
        [1, 'Bruno', 34],
        [2, 'Lindsey', 39],
        [3, 'Roberto', 18],
        [4, 'Yasmin', 22]
      ],
      width: 300,
      height: 400,
      columnWidthsPercentages: <double>[15, 70, 15],
    );

MaterialApp get _baseApp => MaterialApp(
      home: Scaffold(
        body: Container(
          width: 480,
          height: 800,
          child: Center(
            child: _baseWidget,
          ),
        ),
      ),
    );

void main() {
  testWidgets('It should not take any exception', (tester) async {
    await tester.pumpWidget(_baseApp);

    expect(tester.takeException(), null);
  });
  testWidgets('It should find a widget for calling the page 10',
      (tester) async {
    await tester.pumpWidget(_baseApp);
    expect(find.text('10'), findsOneWidget);
  });
}
