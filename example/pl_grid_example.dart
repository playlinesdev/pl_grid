import 'package:flutter/material.dart';
import 'package:pl_grid/pl_grid.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          body: PlGrid(
            headerColumns: ['Id', 'Name', 'Age'],
            data: [
              [1, 'Bruno', 34],
              [2, 'Lindsey', 39],
              [3, 'Roberto', 18],
              [4, 'Yasmin', 22]
            ],
            onPaginationItemClick: (i) async {
              await Future.delayed(Duration(seconds: 3));
              return [];
            },
            columnWidthsPercentages: <double>[15, 70, 15],
            curPage: 1,
            maxPages: 4,
          ),
        ),
      ),
    );
