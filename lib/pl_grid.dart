library pl_grid;

import 'package:flutter/material.dart';

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
class PlGrid extends StatelessWidget {
  final double width, height, headerHeight;
  final List<dynamic> headerColumns;
  final List<List<dynamic>> data;

  ///Callback for searching if the search field is displayed
  final Function(String) onSearch;

  ///The percentage of the whole width that the column has to fit
  final List<double> columnWidthsPercentages;
  final Function(int) paginationItemClick;
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
  final int curPage;

  ///Custom style to apply to the rows
  final TextStyle rowsStyle;

  ///Custom style to apply to the pagination item buttons
  final TextStyle paginationStyle;

  ///Custom style to apply to the header cells
  final TextStyle headerStyle;
  final TextStyle zebraStyle;

  ///Render the widgetas a Card
  final bool asCard;
  final bool applyZebraEffect;
  final bool invertZebra;
  final bool internalGrid;

  final EdgeInsets searchBarPadding;
  final EdgeInsets headerCellsPadding;
  final EdgeInsets rowCellsPadding;
  final bool showSearchBar;
  final InputDecoration searchBarInputDecoration;
  final TextStyle searchBarStyle;
  final TextAlign searchBarTextAlign;
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

  PlGrid({
    this.width = 320,
    this.height = 220,
    this.headerHeight = 30,
    @required this.columnWidthsPercentages,
    @required this.headerColumns,
    this.headerCellsPadding = baseHeaderCellsPadding,
    this.rowCellsPadding = baseRowCellsPadding,
    this.data,
    this.applyZebraEffect = true,
    this.zebraStyle = baseZebraStyle,
    this.invertZebra = false,
    this.onSearch,
    this.searchBarPadding = baseSearchBarPadding,
    this.searchBarInputDecoration = baseSearchBarInputDecoration,
    this.searchBarHeight = 20,
    this.searchBarStyle = baseSearchBarStyle,
    this.showSearchBar = true,
    this.paginationItemClick,
    this.headerCellsColor,
    @required this.maxPages,
    @required this.curPage,
    this.rowsCellRenderer,
    this.headerCellRenderer,
    this.heightByRow,
    this.asCard = true,
    this.alignmentByRow,
    this.internalGrid = false,
    this.headerAlignmentByCells,
    this.noContentWidget,
    this.searchBarTextAlign = TextAlign.start,
    this.asCardPadding = baseAsCardPadding,
    this.headerStyle = baseHeaderStyle,
    this.rowsStyle = baseRowStyle,
    this.paginationStyle = basePaginationStyle,
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
