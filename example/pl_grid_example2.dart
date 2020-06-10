import 'package:flutter/material.dart';
import 'package:pl_grid/pl_grid.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          body: grid,
        ),
      ),
    );

get grid => PlGrid(
      headerColumns: [
        'Id',
        FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.add_box,
              size: 8,
            ),
            label: Text(
              'Product',
              style: TextStyle(fontSize: 13),
            )),
        'Price',
        'Stock',
        'Action'
      ],
      headerStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      rowsCellRenderer: (row, cell, content) {
        if (row == 2 && cell == 2) return Icon(Icons.accessibility_new);
        return null;
      },
      heightByRow: (i) => 35,
      rowsStyle: TextStyle(fontSize: 12),
      width: 320,
      height: 200,
      asCardPadding: EdgeInsets.all(10),
      onPaginationItemClick: (i) {
        print('touched pagination page $i button');
      },
      data: data,
      headerHeight: 25,
      alignmentByRow: (row, cell) => Alignment.topCenter,
      headerAlignmentByCells: (cell) => Alignment.center,
      columnWidthsPercentages: <double>[8, 32, 20, 20, 20],
      curPage: 1,
      maxPages: 2,
    );

get data => [
      [
        1,
        'Pencil',
        1.5,
        30,
        FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.access_alarm,
              size: 10,
            ),
            label: Text(
              'add',
              style: TextStyle(fontSize: 8),
            ))
      ],
      [1, 'Pen', 2.5, 25, 1],
      [1, 'Notebook', 8.5, 20, 1],
      [1, 'Note', 8.5, 20, 1],
      [1, 'Pen', 8.5, 20, 1],
    ];
