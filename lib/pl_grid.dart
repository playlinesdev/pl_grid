library pl_grid;

import 'package:flutter/material.dart';

class PlGrid extends StatelessWidget {
  final double width, height;
  final List<String> headerColumns;
  final List<List<dynamic>> data;
  final List<double> columnWidthsPercentages;
  final Function(int) paginationItemClick;
  final int maxPages;
  final int curPage;
  final TextStyle resultsStyle;
  final TextStyle paginationStyle;
  final TextStyle headerStyle;

  ///Render the widgetas a Card
  final bool asCard;

  ///If rendering as a Card, sets the internal padding from the edge of the
  final EdgeInsets asCardPadding;

  ///Widget to display when theres no registers to display
  final Widget noContentWidget;

  ///A function that receives the index of the cell, the string content and
  ///returns a widget to render the content of that cell
  final Widget Function(int, String) resultsCellRenderer;

  PlGrid({
    this.width = 200,
    this.height = 150,
    this.columnWidthsPercentages,
    this.headerColumns,
    this.data,
    this.paginationItemClick,
    this.maxPages,
    this.curPage,
    this.resultsCellRenderer,
    this.asCard = true,
    this.noContentWidget,
    this.asCardPadding = const EdgeInsets.all(2),
    this.headerStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    this.resultsStyle =
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
              height: headerStyle.fontSize + (headerStyle.fontSize / 10).ceil(),
            ),
            Expanded(
                child: Scrollbar(
              child: data.length > 0
                  ? _tableResults()
                  : noContentWidget ?? Container(),
            )),
            Container(
                child: Scrollbar(
                  child: _pagination(),
                ),
                height: paginationStyle.fontSize * 2)
          ],
        ),
      );

  Widget _tableHeader() {
    return _makeRow(headerColumns, style: headerStyle);
  }

  Row _makeRow(
    List<String> cells, {
    bool top = true,
    bool bottom = true,
    TextStyle style,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(cells.length, (i) {
        bool left = i == 0, right = true;
        return Container(
          decoration: BoxDecoration(
              border: _makeBorder(
                  top: top, left: left, bottom: bottom, right: right)),
          child: Padding(
            padding: EdgeInsets.only(left: 2),
            child: resultsCellRenderer == null
                ? Text(cells[i].toString(), style: style ?? resultsStyle)
                : resultsCellRenderer(i, cells[i]),
          ),
          width: _getColumnWidth(i),
        );
      }),
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

  Widget _tableResults() {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (ctx, i) => _makeRow(
        data[i],
        top: false,
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
    return '[AgendaGrid] $error';
  }
}
