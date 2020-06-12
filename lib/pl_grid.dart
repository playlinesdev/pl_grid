///This is a widget component that aims to display a data grid with pagination and other
///features such as built in search bar, sort, group, filter, etc in simple
///widget like so:
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

///A function that takes in the last String the user typed and the current one and returns a rule
///if it should or not to notify a onSearch event
typedef bool WillNotifySearch(
    String lastSearchInput, String currentSearchInput);

///The main class. Use it like
class PlGrid extends StatefulWidget {
  ///A key for the Widget
  final Key key;

  ///The whole width of the PlGrid widget
  final double width;

  ///Theme to apply to the grid. If it's not supplied will use upper theme's such as the very
  ///MaterialApp theme
  final ThemeData themeData;

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

  ///Callback for searching if the search field is displayed. The callback shall be
  ///async and has to return a List<List>. The return is data to update the grid
  ///if it returns null, the data inside the grid will not be modified. because
  ///the setState method won't be called for the data property. Do not call
  ///setState by yourself to change the data inside the grid, unless you really
  ///want to. To modify the data in the grid, just return new data from the [onSearch]
  ///function parameter or the onPaginationItemClick parameter or others that will
  ///be implemented in later versions.
  ///To implement a simple query in on the data you could use something like this:
  ///```dart
  ///PlGrid(
  ///   onSearch: (typedOnSearchField) async {
  ///     var response = await callApiGetMethod(query: typedOnSearchField)
  ///     //the response.data will be the new data inside the grid. If it's null
  ///     //it means you don't want to update the data. If you pass an empty list,
  ///     //like return []; it will empty the data inside your pl_grid
  ///     return response.data;
  ///   },
  ///)
  ///```
  ///
  final Future<List<List>> Function(String) onSearch;

  ///The percentage of the whole width that the column has to fit
  final List<double> columnWidthsPercentages;

  ///A function that takes an int for the page and performs an action when the user
  ///touches or clicks a pagination index
  ///```dart
  ///PlGrid(paginationItemClick: (i) => callApiGetMethod(page: i))
  ///```
  final Future<List<List>> Function(int) onPaginationItemClick;

  ///A function that takes in the index of the a header cell and returns a color for it's background
  ///```dart
  /////applies a "zebra effect" on the cells of the header
  ///PlGrid(headerCellsColor: (i)=> i % 2 == 0 ? Colors.white : Colors.grey)
  ///```
  final Color Function(int) headerCellsColor;

  ///Called on asynchronous errors such as on onSearch or onPaginationItemClick methods
  final Function(dynamic) onError;

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

  ///A function that receives what user typed on searchbar and will only notify
  ///onSearch event if the condition is satisfied. For example:
  ///```dart
  ///PlGrid(
  ///   onSearch: (typedSearch){
  ///
  ///   },
  ///   notifySearchOnlyIf: (lastTypedSearch, typedSearch) {
  ///     //returns true if the typed String length is greather than 3
  ///     //or if the user is deleting a character
  ///     return typedSearch.length > 3 || (lastTypedSearch.length < typedSearch.length);
  ///   }
  ///)
  ///```
  final WillNotifySearch notifySearchOnlyIf;

  ///A period to wait from the time the user starts typing to in fact the
  ///time the widget will notify an onSearchType event so that it would not update
  ///for every character typed or deleted. The period is in milliseconds
  final int searchInterval;

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
    this.key,
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
    this.notifySearchOnlyIf,
    this.searchInterval,
    this.themeData,
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
    this.onPaginationItemClick,
    this.rowsCellRenderer,
    this.onError,
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

  String _logError(String error) {
    return '[PlGrid] $error';
  }

  @override
  _PlGridState createState() => _PlGridState();
}

class _PlGridState extends State<PlGrid> {
  String lastSearch = '';
  int lastMilliseconds;
  List<List> _data;
  var _searchController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    lastMilliseconds = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.themeData != null) {
      return Theme(data: widget.themeData, child: _getWidget());
    }
    return _getWidget();
  }

  Widget _getWidget() {
    if (widget.asCard)
      return Card(
        key: widget.key,
        child: Padding(
          padding: widget.asCardPadding,
          child: content,
        ),
      );
    return content;
  }

  Widget get content => Container(
        key: widget.asCard
            ? null
            : widget.key, //if asCard, the key is in the Card
        width: widget.width,
        height: widget.height,
        child: Column(
          children: <Widget>[
            if (widget.showSearchBar)
              Container(
                height: widget.searchBarPadding == null ? 20 : null,
                alignment: Alignment.topRight,
                child: _searchBar(),
              ),
            Container(child: _tableHeader()),
            Container(height: 1, color: Colors.black),
            Expanded(
              child: _data.length > 0
                  ? _tableRows()
                  : widget.noContentWidget ?? Container(),
            ),
            Container(
                child: Scrollbar(
                  child: _pagination(),
                ),
                height: widget.paginationStyle.fontSize * 2)
          ],
        ),
      );

  Widget _searchBar() {
    return Padding(
      padding: widget.searchBarPadding,
      child: Container(
        height: widget.searchBarHeight,
        child: TextFormField(
          controller: _searchController,
          textAlign: widget.searchBarTextAlign,
          onChanged: (typed) {
            //if the widget.onSearch was not passed, nothing else should execute
            if (widget.onSearch != null) {
              _handleSearchEvent(typedText: typed);
            }
          },
          style: widget.searchBarStyle,
          decoration: widget.searchBarInputDecoration,
        ),
      ),
    );
  }

  ///Decides if the widget.onSearch event will or will not be called
  ///depending on the widget.searchInterval and widget.notifyOnlyIf parameters
  void _handleSearchEvent({String typedText}) async {
    //if the interval is not completed will not call the widget.onSearch
    if (_completedInterval) {
      //once completed, resets it
      setState(() {
        _resetSearchInterval();
      });

      //if the call of typedTex contains the same text of the previous call or
      //if the call came from a schedule and the current _searchController.text is
      //already equals to the last search, ignore the event
      if (typedText == lastSearch ||
          (typedText == null &&
              _searchController.text.isNotEmpty &&
              _searchController.text == lastSearch)) {
        return;
      }

      //if the widget.notifySearchOnlyIf is passed, checks it
      if (widget.notifySearchOnlyIf == null ||
          (widget.notifySearchOnlyIf != null &&
              widget.notifySearchOnlyIf(lastSearch, typedText))) {
        //will call the widget.onSearch
        widget.onSearch(typedText ?? _searchController.text).then((newData) {
          //if newData came from the widget.onSearch
          if (newData != null) {
            setState(() {
              _data = newData;
            });
          }
        }).catchError((error) {
          _throwError(error);
        });
      }
    } else {
      //if the _handleSearchEvent is called whithin the search interval, schedules a new try
      Future.delayed(
        Duration(milliseconds: widget.searchInterval - elapsedMilliseconds),
      )
          .then(
        (value) => _handleSearchEvent(),
      )
          .catchError((error) {
        _throwError(error);
      });
    }
  }

  void _throwError(dynamic error) {
    if (widget.onError != null) widget.onError(error);
  }

  ///Resets the search interval making it equals to the current millisecondsSinceEpoch
  void _resetSearchInterval() {
    lastMilliseconds = DateTime.now().millisecondsSinceEpoch;
  }

  ///if the widget.searchInterval argument was provided, checks if the
  ///elapsed time is already bigger than or equals to the given value
  bool get _completedInterval {
    if (widget.searchInterval != null)
      return elapsedMilliseconds >= widget.searchInterval;
    return true;
  }

  ///measures the elapsed time
  int get elapsedMilliseconds =>
      DateTime.now().millisecondsSinceEpoch - lastMilliseconds;

  ///Builds the table header
  Widget _tableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.headerColumns.length, (i) {
        bool left = i == 0, right = true;
        Widget cellWidget = widget.headerCellRenderer != null
            ? widget.headerCellRenderer(i, widget.headerColumns[i])
            : null;
        return Container(
          width: _getColumnWidth(i),
          height: widget.headerHeight,
          alignment: widget.headerAlignmentByCells != null
              ? widget.headerAlignmentByCells(i)
              : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: widget.headerCellsColor != null
                ? widget.headerCellsColor(i)
                : null,
            border: _makeBorder(
              top: widget.internalGrid ? true : false,
              left: widget.internalGrid ? left : false,
              bottom: false,
              right: widget.internalGrid ? right : false,
            ),
          ),
          child: Padding(
            padding: widget.headerCellsPadding,
            child: cellWidget != null
                ? cellWidget
                : widget.headerColumns[i] is Widget
                    ? widget.headerColumns[i]
                    : Text(widget.headerColumns[i].toString(),
                        style: widget.headerStyle),
          ),
        );
      }),
    );
  }

  ///Builds a table row
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
        var _style =
            widget.applyZebraEffect && zebra ? widget.zebraStyle : style;
        Widget cellWidget = widget.rowsCellRenderer != null
            ? widget.rowsCellRenderer(rowNumber, i, cells[i])
            : null;
        if (cellWidget == null) {
          cellWidget = cells[i] is Widget
              ? cells[i]
              : Text(cells[i].toString(), style: _style ?? widget.rowsStyle);
        }
        return Container(
          height:
              widget.heightByRow != null ? widget.heightByRow(rowNumber) : null,
          width: _getColumnWidth(i),
          alignment: widget.alignmentByRow != null
              ? widget.alignmentByRow(rowNumber, i)
              : Alignment.centerLeft,
          decoration: BoxDecoration(
              boxShadow: widget.applyZebraEffect && zebra
                  ? [BoxShadow(color: Colors.grey[200])]
                  : null,
              border: _makeBorder(
                top: false,
                left: widget.internalGrid ? left : false,
                bottom: widget.internalGrid ? bottom : false,
                right: widget.internalGrid ? right : false,
              )),
          child: Padding(
            padding: widget.rowCellsPadding,
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

  ///Creates the border of the container for each cell
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

  ///Builds all the rows
  Widget _tableRows() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _data.length,
      separatorBuilder: (BuildContext context, int index) => Container(
        height: 1,
        color: Colors.black26,
      ),
      itemBuilder: (ctx, i) => _makeRow(
        _data[i],
        top: false,
        zebra: widget.invertZebra ? i % 2 != 0 : i % 2 == 0,
        rowNumber: i,
      ),
    );
  }

  ///Builds the pagination widget
  Widget _pagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        decoration: BoxDecoration(
            border: widget.internalGrid
                ? null
                : Border(top: BorderSide(width: 0.7, color: Colors.black54))),
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (ctx, i) =>
                Container(width: widget.paginationStyle.fontSize / 2),
            itemCount: widget.maxPages,
            itemBuilder: (ctx, index) {
              var i = index + 1;
              var style = widget.paginationStyle;
              if (i != widget.curPage)
                style = style.copyWith(color: Colors.blue);

              return Container(
                child: _pageNumberWidget(i, style: style),
                width: (widget.width / style.fontSize / 2) +
                    (style.fontSize * i.toString().length),
              );
            }),
      ),
    );
  }

  ///Builds the page number
  Widget _pageNumberWidget(int i, {TextStyle style}) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      onPressed: i != widget.curPage && widget.onPaginationItemClick != null
          ? () => _handlePaginationClick(i)
          : null,
      visualDensity: VisualDensity(horizontal: 1),
      child: Text(i.toString(), style: style),
    );
  }

  ///Performs the widget.onPaginationItemClick and in an await
  ///call and if it returns new data, updates the data
  void _handlePaginationClick(int i) {
    widget.onPaginationItemClick(i).then((newData) {
      if (newData != null) {
        setState(() {
          _data = newData;
        });
      }
    }).catchError((error) {
      _throwError(error);
    });
  }

  ///returns the width of each column by it's index
  double _getColumnWidth(int index) {
    return widget.columnWidthsPercentages != null &&
            widget.columnWidthsPercentages.length >= widget.headerColumns.length
        ? widget.columnWidthsPercentages[index] / 100 * widget.width
        : widget.width / widget.headerColumns.length;
  }
}
