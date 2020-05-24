library pl_grid;

import 'package:flutter/material.dart';

class PlGrid extends StatelessWidget {
  final double width, height, headerHeight;
  final List<dynamic> headerColumns;
  final List<List<dynamic>> data;

  ///The percentage of the whole width that the column has to fit
  final List<double> columnWidthsPercentages;
  final Function(int) paginationItemClick;

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

  ///Render the widgetas a Card
  final bool asCard;

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

  PlGrid({
    this.width = 200,
    this.height = 150,
    this.headerHeight = 30,
    @required this.columnWidthsPercentages,
    @required this.headerColumns,
    this.data,
    this.paginationItemClick,
    @required this.maxPages,
    @required this.curPage,
    this.rowsCellRenderer,
    this.headerCellRenderer,
    this.heightByRow,
    this.asCard = true,
    this.alignmentByRow,
    this.headerAlignmentByCells,
    this.noContentWidget,
    this.asCardPadding = const EdgeInsets.all(2),
    this.headerStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    this.rowsStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    this.paginationStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
            Container(
              child: _tableHeader(),
            ),
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

  Widget _tableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(headerColumns.length, (i) {
        bool left = i == 0, right = true;
        Widget cellWidget = headerCellRenderer != null
            ? headerCellRenderer(i, headerColumns[i])
            : null;
        return Container(
          height: headerHeight,
          alignment: headerAlignmentByCells != null
              ? headerAlignmentByCells(i)
              : Alignment.center,
          decoration: BoxDecoration(
            border: _makeBorder(
              top: true,
              left: left,
              bottom: true,
              right: right,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 2),
            child: cellWidget ?? headerColumns[i] is Widget
                ? headerColumns[i]
                : Text(headerColumns[i].toString(), style: headerStyle),
          ),
          width: _getColumnWidth(i),
        );
      }),
    );
  }

  _makeRow(
    List cells, {
    bool top = true,
    bool bottom = true,
    int rowNumber,
    TextStyle style,
  }) {
    List<Widget> cellWidgets = List.generate(
      cells.length,
      (i) {
        bool left = i == 0, right = true;
        Widget cellWidget = rowsCellRenderer != null
            ? rowsCellRenderer(rowNumber, i, cells[i])
            : null;
        if (cellWidget == null) {
          cellWidget = cells[i] is Widget
              ? cells[i]
              : Text(cells[i].toString(), style: style ?? rowsStyle);
        }
        return Container(
          height: heightByRow != null ? heightByRow(rowNumber) : null,
          alignment: alignmentByRow != null
              ? alignmentByRow(rowNumber, i)
              : Alignment.center,
          decoration: BoxDecoration(
              border: _makeBorder(
                  top: top, left: left, bottom: bottom, right: right)),
          child: Padding(
            padding: EdgeInsets.only(left: 2),
            child: cellWidget,
          ),
          width: _getColumnWidth(i),
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
  }) =>
      Border(
        left: left ? _border : BorderSide.none,
        top: top ? _border : BorderSide.none,
        right: right ? _border : BorderSide.none,
        bottom: bottom ? _border : BorderSide.none,
      );

  BorderSide get _border => BorderSide(color: Colors.black38, width: 0.5);

  Widget _tableRows() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: data.length,
      itemBuilder: (ctx, i) => _makeRow(
        data[i],
        top: false,
        rowNumber: i,
      ),
    );
  }

  Widget _pagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.7, color: Colors.black54))),
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
