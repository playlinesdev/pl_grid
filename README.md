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