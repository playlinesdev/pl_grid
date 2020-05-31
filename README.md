
<a href="https://www.buymeacoffee.com/playlinesdev" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

# pl_grid

The PlGrid is a grid view for showing data in a table with a sticky header and pagination components.

## Getting Started

To add the grid on your project, install it by adding the pl_grid package dependency to your pubspec.yaml file, then import the PlGrid class like so: 
```dart
import 'package:pl_grid/pl_grid.dart';
````
Add the widget like in the example down below:

```dart
PlGrid(
    headerColumns: ['Id', 'Name', 'Age'],
    data: [
        [1, 'Bruno', 34],
        [2, 'Lindsey', 39],
        [3, 'Roberto', 18],
        [4, 'Yasmin', 22]
    ],
    columnWidthsPercentages: [15, 70, 15],
    curPage: 1,
    maxPages: 4,
    width: 300,
    height: 200,
)
```

and it will produce the following:

<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample1.png?raw=true"/>

One can also use other parameters for example paginationItemClick that is a function that receives the index of the page touched/clicked to execute any routine such as call api with next page results

The property asCard is set as default to true, but could be set to false, producing the following:

<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample1.png?raw=true"/>

<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample2.png?raw=true"/>
<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample_web.png?raw=true"/>


A complex example to show the many features that can be achieved with this package

```dart
Scaffold(
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
```

<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample_complex.png?raw=true"/>
<img src="https://github.com/playlinesdev/pl_grid/blob/master/sample_complex1.png?raw=true"/>
