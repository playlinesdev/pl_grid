import 'package:flutter/material.dart';
import 'package:pl_grid/pl_grid.dart';

class PlGridExample extends StatefulWidget {
  @override
  _PlGridExampleState createState() => _PlGridExampleState();
}

class _PlGridExampleState extends State<PlGridExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 80),
        child: Container(
          child: PlGrid(
            internalGrid: true,
            width: 480,
            height: 400,
            asCard: true,
            invertZebra: true,
            searchBarHeight: 30,
            searchBarTextAlign: TextAlign.center,
            showSearchBar: true,
            paginationItemClick: (pageClicked) {
              print('Call the api with page attribute');
            },
            noContentWidget: Center(
              child: Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
            onSearch: (searchTextTyped) {
              print(searchTextTyped);
            },
            headerCellRenderer: (cell, content) => cell == 2
                ? FlatButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(content),
                        Icon(Icons.settings_applications)
                      ],
                    ),
                  )
                : null,
            headerAlignmentByCells: (i) =>
                i % 2 == 0 ? Alignment.topRight : Alignment.bottomRight,
            asCardPadding: PlGrid.baseAsCardPadding.copyWith(left: 35),
            headerCellsColor: (i) => Colors.blueGrey[50],
            heightByRow: (row) => row == 2 ? 40 : null,
            rowsCellRenderer: (row, cell, content) => row == 2 && cell == 2
                ? Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.redAccent,
                  )
                : null,
            zebraStyle: PlGrid.baseZebraStyle.copyWith(color: Colors.blueGrey),
            rowCellsPadding: PlGrid.baseRowCellsPadding.copyWith(right: 10),
            alignmentByRow: (row, cell) => row == 2 && cell == 2
                ? Alignment(-0.85, -1)
                : Alignment.bottomRight,
            headerStyle: PlGrid.baseHeaderStyle.copyWith(fontSize: 13),
            columnWidthsPercentages: <double>[25, 25, 25, 25],
            headerColumns: ['Id', 'Name', 'Age', 'aa'],
            maxPages: 3,
            curPage: 1,
            data: [
              [1, 'Person A', 9, 'abc'],
              [2, 'Person B', 18, 'abc'],
              [3, 'Person C', 75, 'abc'],
              [4, 'Person D', 31, 'abc'],
              [5, 'Person E', 26, 'abc'],
              [6, 'Person F', 52, 'abc'],
              [7, 'Person G', 13, 'abc'],
              [8, 'Person H', 24, 'abc'],
            ],
          ),
        ),
      ),
    );
  }
}
