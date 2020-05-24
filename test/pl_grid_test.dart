import 'package:flutter_test/flutter_test.dart';

import 'package:pl_grid/pl_grid.dart';

void main() {
  testWidgets('It should not take any exception', (tester) async {
    await tester.pumpWidget(
      PlGrid(
        headerColumns: ['Id', 'Name', 'Age'],
        data: [
          [1, 'Bruno', 34],
          [2, 'Lindsey', 39],
          [3, 'Roberto', 18],
          [4, 'Yasmin', 22]
        ],
      ),
    );

    expect(tester.takeException(), null);
  });
}
