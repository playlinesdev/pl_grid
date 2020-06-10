///This is a widget component that aims to display a data grid with pagination and other
///features such as built in search bar, sort, group, filter, etc in simple
///statless widget like so:
///
///![](https://github.com/playlinesdev/pl_grid/blob/master/sample1.png?raw=true)
///
///It's possible to use any widget in any cell including the header making the grid very
///flexible. A very simple use case would be like so
///```dart
///PlGrid(
///   headerColumns: ['Id', 'Name', 'Age'],
///   data: [
///     [1, 'Bruno', 34],
///     [2, 'Lindsey', 39],
///     [3, 'Roberto', 18],
///     [4, 'Yasmin', 22]
///   ],
///   columnWidthsPercentages: <double>[15, 70, 15],
///   curPage: 1,
///   maxPages: 4,
///)
///```
library pl_grid;

import 'package:flutter/material.dart';

///The main class. Use it like
class PlGrid extends StatelessWidget {
  ///The whole width of the PlGrid widget
  final double width;

  ///The whole height of the PlGrid widget
  final double height;

  ///The height of the header line
  final double headerHeight;

  ///A list of objects representing each header cell. Will accept a simple string and use
  ///simple Text with the headerStyle or any Widget since it fits in the [headerHeight]
  ///```dart
  ///PlGrid(
  ///   headerColumns: [Text('Header 1'), 'Header 2'],
  ///)
  ///```
  final List<dynamic> headerColumns;

  ///A List of a List of objects representing rows and column cells. Will accept Strings or Widgets
  ///```dart
  /// PlGrid(
  ///    data: [
  ///       [1, 'Bruno', 34],
  ///       [1, 'Roberto', Text('34', style: TextStyle(fontSize: 20))],
  ///    ]
  /// )
  ///```
  final List<List<dynamic>> data;

  ///Callback for searching if the search field is displayed
  ///```dart
  ///PlGrid(
  ///   onSearch: (typedOnSearchField){
  ///     callApiGetMethod(query: typedOnSearchField)
  ///   },
  ///)
  ///```
  final Function(String) onSearch;

  ///The percentage of the whole width that the column has to fit
  final List<double> columnWidthsPercentages;

  ///A function that takes an int for the page and performs an action when the user
  ///touches or clicks a pagination index
  ///```dart
  ///PlGrid(paginationItemClick: (i) => callApiGetMethod(page: i))
  ///```
  final Function(int) paginationItemClick;

  ///A function that takes in the index of the a header cell and returns a color for it's background
  ///```dart
  /////applies a "zebra effect" on the cells of the header
  ///PlGrid(headerCellsColor: (i)=> i % 2 == 0 ? Colors.white : Colors.grey)
  ///```
  final Color Function(int) headerCellsColor;

  ///Sets the height of each row manually
  ///```dart
  /// PlGrid(
  ///   heightByRow: (row){
  ///  //null would size automatically as if you
  ///  //haven't passed the height to the container
  ///  return row == 2 ? 40 : null;
  ///  }
  /// )
  ///```
  final double Function(int) heightByRow;

  ///Sets the row cells alignment in a row manually
  ///```dart
  /// PlGrid(
  ///   alignmentByRow: (row,cell){
  ///  return row == 2 && cell == 2 ? Alignment.topRight : null;
  ///  }
  /// )
  ///```
  final Alignment Function(int, int) alignmentByRow;

  ///Sets the header cells alignment manually
  ///```dart
  /// PlGrid(
  ///   alignmentByRow: (cell){
  ///  return cell == 2 ? Alignment.topRight : null;
  ///  }
  /// )
  ///```
  final Alignment Function(int) headerAlignmentByCells;

  ///Max number of pages starting on page 1
  final int maxPages;

  ///The current page that is beign ehxibited
  final int curPage;

  ///Custom style to apply to the rows
  final TextStyle rowsStyle;

  ///Custom style to apply to the pagination item buttons
  final TextStyle paginationStyle;

  ///Custom style to apply to the header cells
  final TextStyle headerStyle;

  ///A style for the "zebra effect affected" rows in case parameter [applyZebraEffect] is set to true
  final TextStyle zebraStyle;

  ///Render the widgetas a Card
  final bool asCard;

  ///Marks to use zebra effect on rows
  final bool applyZebraEffect;

  ///Reverts the zebra effect to apply the effect on odd or even indexes
  final bool invertZebra;

  ///Marks if the PlGrid should show or not inner grid lines
  final bool internalGrid;

  ///Padding to be applied on the search bar in case parameter [showSearchBar] is
  ///set to true
  final EdgeInsets searchBarPadding;

  ///Padding to be applied on every and each header cell
  final EdgeInsets headerCellsPadding;

  ///Padding to be applied on every and each row cell
  final EdgeInsets rowCellsPadding;

  ///Wheather to show or not the searchbar
  final bool showSearchBar;

  ///Input decoration for the searchbar widget
  ///```dart
  ///PlGrid(
  ///   searchBarInputDecoration: InputDecoration(
  ///       border: OutlineInputBorder(),
  ///       fillColor: Colors.blueGrey,
  ///   ),
  ///)
  ///```
  final InputDecoration searchBarInputDecoration;

  ///A style to apply on the searchbar
  final TextStyle searchBarStyle;

  ///Searchbar text align property
  final TextAlign searchBarTextAlign;

  ///The height for the searchbar widget
  final double searchBarHeight;

  ///If rendering as a Card, sets the internal padding from the edge of the
  final EdgeInsets asCardPadding;

  ///Widget to display when theres no registers to display
  final Widget noContentWidget;

  ///A function that receives the index of the cell, the content and
  ///returns a widget to render the content of that cell
  final Widget Function(int row, int cell, dynamic) rowsCellRenderer;

  ///A function that receives the index of the header cell, the content and
  ///returns a widget to render the content of that cell
  final Widget Function(int, dynamic) headerCellRenderer;

  static const baseSearchBarInputDecoration = InputDecoration(
    suffixIcon: Icon(Icons.search, size: 16),
    contentPadding: EdgeInsets.only(bottom: 12, left: 4),
    hintText: 'Search...',
    border: UnderlineInputBorder(),
    filled: true,
  );

  static const baseSearchBarPadding =
      const EdgeInsets.only(left: 180, top: 5, bottom: 5, right: 0);
  static const baseAsCardPadding = const EdgeInsets.all(4);
  static const baseHeaderCellsPadding = EdgeInsets.only(left: 10);
  static const baseRowCellsPadding =
      EdgeInsets.only(left: 10, top: 5, bottom: 5);

  static const baseSearchBarStyle = const TextStyle(fontSize: 14);
  static const baseHeaderStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const baseRowStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const baseZebraStyle = TextStyle(
      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal);
  static const basePaginationStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  ///Constructs a grid with the given parameters
  ///For many of the constructor input uses static const values that can be used with a
  ///copyWith method if it's necessary to change just some of the standard properties like so.
  ///It's always a PlGrid.base[... something]. For example:
  ///```dart
  ///PlGrid(
  ///   headerStyle: PlGrid.baseHeaderStyle.copyWith(color: Colors.blue),
  ///   searchBarStyle: PlGrid.baseSearchBarStyle.copyWith(fontSize: 30),
  ///)
  ///```
  PlGrid({
    this.width = 320,
    this.height = 220,
    this.headerHeight = 30,
    @required this.columnWidthsPercentages,
    @required this.headerColumns,
    @required this.maxPages,
    @required this.curPage,
    this.headerCellsPadding = baseHeaderCellsPadding,
    this.applyZebraEffect = true,
    this.rowCellsPadding = baseRowCellsPadding,
    this.zebraStyle = baseZebraStyle,
    this.invertZebra = false,
    this.searchBarPadding = baseSearchBarPadding,
    this.searchBarInputDecoration = baseSearchBarInputDecoration,
    this.searchBarHeight = 20,
    this.searchBarStyle = baseSearchBarStyle,
    this.showSearchBar = true,
    this.asCard = true,
    this.internalGrid = false,
    this.searchBarTextAlign = TextAlign.start,
    this.asCardPadding = baseAsCardPadding,
    this.headerStyle = baseHeaderStyle,
    this.rowsStyle = baseRowStyle,
    this.paginationStyle = basePaginationStyle,
    this.headerAlignmentByCells,
    this.alignmentByRow,
    this.data,
    this.headerCellRenderer,
    this.headerCellsColor,
    this.heightByRow,
    this.noContentWidget,
    this.onSearch,
    this.paginationItemClick,
    this.rowsCellRenderer,
  }) {
    if (headerColumns == null)
      throw Exception(_logError('Headers can\'t be null'));
    if (columnWidthsPercentages != null &&
        columnWidthsPercentages.length > headerColumns.length)
      throw Exception(_logError(
          'columnWidthsPercentages length can\'t be greater than headerColumns length'));
    if (columnWidthsPercentages != null &&
        columnWidthsPercentages.reduce((value, element) => value + element) >
            100)
      throw Exception(_logError('columnWidth\'s sum is greather than 100'));
  }

  @override
  Widget build(BuildContext context) {
    if (asCard)
      return Card(
        child: Padding(
          padding: asCardPadding,
          child: content,
        ),
      );
    return content;
  }

  Widget get content => Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            if (showSearchBar)
              Container(
                height: searchBarPadding == null ? 20 : null,
                alignment: Alignment.topRight,
                child: _searchBar(),
              ),
            Container(child: _tableHeader()),
            Container(height: 1, color: Colors.black),
            Expanded(
              child: data.length > 0
                  ? _tableRows()
                  : noContentWidget ?? Container(),
            ),
            Container(
                child: Scrollbar(
                  child: _pagination(),
                ),
                height: paginationStyle.fontSize * 2)
          ],
        ),
      );

  Widget _searchBar() {
    return Padding(
      padding: searchBarPadding,
      child: Container(
        height: searchBarHeight,
        child: TextFormField(
          textAlign: searchBarTextAlign,
          onChanged: onSearch,
          style: searchBarStyle,
          decoration: searchBarInputDecoration,
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(headerColumns.length, (i) {
        bool left = i == 0, right = true;
        Widget cellWidget = headerCellRenderer != null
            ? headerCellRenderer(i, headerColumns[i])
            : null;
        return Container(
          width: _getColumnWidth(i),
          height: headerHeight,
          alignment: headerAlignmentByCells != null
              ? headerAlignmentByCells(i)
              : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: headerCellsColor != null ? headerCellsColor(i) : null,
            border: _makeBorder(
              top: internalGrid ? true : false,
              left: internalGrid ? left : false,
              bottom: false,
              right: internalGrid ? right : false,
            ),
          ),
          child: Padding(
            padding: headerCellsPadding,
            child: cellWidget != null
                ? cellWidget
                : headerColumns[i] is Widget
                    ? headerColumns[i]
                    : Text(headerColumns[i].toString(), style: headerStyle),
          ),
        );
      }),
    );
  }

  _makeRow(
    List cells, {
    bool top = true,
    bool bottom = true,
    bool zebra = false,
    int rowNumber,
    TextStyle style,
  }) {
    List<Widget> cellWidgets = List.generate(
      cells.length,
      (i) {
        bool left = i == 0, right = true;
        var _style = applyZebraEffect && zebra ? zebraStyle : style;
        Widget cellWidget = rowsCellRenderer != null
            ? rowsCellRenderer(rowNumber, i, cells[i])
            : null;
        if (cellWidget == null) {
          cellWidget = cells[i] is Widget
              ? cells[i]
              : Text(cells[i].toString(), style: _style ?? rowsStyle);
        }
        return Container(
          height: heightByRow != null ? heightByRow(rowNumber) : null,
          width: _getColumnWidth(i),
          alignment: alignmentByRow != null
              ? alignmentByRow(rowNumber, i)
              : Alignment.centerLeft,
          decoration: BoxDecoration(
              boxShadow: applyZebraEffect && zebra
                  ? [BoxShadow(color: Colors.grey[200])]
                  : null,
              border: _makeBorder(
                top: false,
                left: internalGrid ? left : false,
                bottom: internalGrid ? bottom : false,
                right: internalGrid ? right : false,
              )),
          child: Padding(
            padding: rowCellsPadding,
            child: cellWidget,
          ),
        );
      },
    );
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: cellWidgets,
    );
  }

  Border _makeBorder({
    bool top = true,
    bool left = true,
    bool right = true,
    bool bottom = true,
    Color borderColor = Colors.black38,
    double width = 0.5,
  }) =>
      Border(
        left: left ? _border(borderColor, width) : BorderSide.none,
        top: top ? _border(borderColor, width) : BorderSide.none,
        right: right ? _border(borderColor, width) : BorderSide.none,
        bottom: bottom ? _border(borderColor, width) : BorderSide.none,
      );

  BorderSide _border([Color color, double width]) =>
      BorderSide(color: color, width: width);

  Widget _tableRows() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) => Container(
        height: 1,
        color: Colors.black26,
      ),
      itemBuilder: (ctx, i) => _makeRow(
        data[i],
        top: false,
        zebra: invertZebra ? i % 2 != 0 : i % 2 == 0,
        rowNumber: i,
      ),
    );
  }

  Widget _pagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        decoration: BoxDecoration(
            border: internalGrid
                ? null
                : Border(top: BorderSide(width: 0.7, color: Colors.black54))),
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (ctx, i) =>
                Container(width: paginationStyle.fontSize / 2),
            itemCount: maxPages,
            itemBuilder: (ctx, index) {
              var i = index + 1;
              var style = paginationStyle;
              if (i != curPage) style = style.copyWith(color: Colors.blue);

              return Container(
                child: _pageNumberWidget(i, style: style),
                width: (width / style.fontSize / 2) +
                    (style.fontSize * i.toString().length),
              );
            }),
      ),
    );
  }

  Widget _pageNumberWidget(int i, {TextStyle style}) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      onPressed: i != curPage
          ? () {
              paginationItemClick(i);
            }
          : null,
      visualDensity: VisualDensity(horizontal: 1),
      child: Text(i.toString(), style: style),
    );
  }

  double _getColumnWidth(int index) {
    return columnWidthsPercentages != null &&
            columnWidthsPercentages.length >= headerColumns.length
        ? columnWidthsPercentages[index] / 100 * width
        : width / headerColumns.length;
  }

  String _logError(String error) {
    return '[PlGrid] $error';
  }
}
