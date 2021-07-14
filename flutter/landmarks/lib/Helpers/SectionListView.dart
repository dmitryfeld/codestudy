import 'package:flutter/material.dart';

typedef int NumberOfRowsDatasource(int section);
typedef int NumberOfSectionDatasource();
typedef Widget SectionWidgetDatasource(int section);
typedef Widget RowsWidgetDatasource(int section, int row);
typedef void OnScroll(IndexPath path);

@immutable class IndexPath {
    final int section;
    final int row;
    IndexPath({this.section, this.row});
    @override String toString() {
        return 'section: $section, row: $row';
    }
    IndexPath apply({int section,int row}){
        return IndexPath(
            section: section == null ? this.section : section,
            row:  row == null ? this.row : row
        );
    }
}

@immutable class SectionListView extends StatefulWidget {
    final OnScroll onScroll;
    final NumberOfSectionDatasource numberOfSection;
    final NumberOfRowsDatasource numberOfRowsInSection;
    final SectionWidgetDatasource sectionWidget;
    final RowsWidgetDatasource rowWidget;
    final IndexPath sectionRow;

    SectionListView({
        this.sectionRow,
        this.onScroll,
        this.numberOfSection,
        @required this.numberOfRowsInSection,
        this.sectionWidget,
        @required this.rowWidget,
    }) : assert(!(numberOfRowsInSection == null || rowWidget == null),'numberOfRowsInSection and rowWidget are mandatory');

    @override SectionListViewState createState() {
        return SectionListViewState();
    }
}

class SectionListViewState extends State<SectionListView> {
    List<int> _itemList = new List<int>.empty(growable: true);
    int _itemCount = 0;
    int _sectionCount = 0;
    ScrollController _listController;

    @override void initState() {
        super.initState();
        this._sectionCount = widget.numberOfSection();
        this._itemCount = this._listItemCount();

        this._listController = TrackingScrollController(
            initialScrollOffset: widget.sectionRow == null ? 0.0 : 56.0 * this._rowIndex(widget.sectionRow)
        );
    }

    @override Widget build(BuildContext context) {
        return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification){
                if (scrollNotification is ScrollEndNotification) {
                    double pixels = _listController.position.pixels;
                    double divider = 56;// + (pixels / 27853) * 0.1;
                    double dindex = (pixels.truncateToDouble() / divider);
                    int index = dindex.truncate();
                    print('pixels: $pixels dindex: $dindex INDEX: $index');
                    if (widget.onScroll != null) {
                        widget.onScroll(this._sectionModel(index));
                    }
                }
            },
            child: ListView.separated(
                controller: this._listController,
                itemCount: this._itemCount,
                itemBuilder: (context, index) {
                    return this._buildItemWidget(index);
                },
                separatorBuilder: (context,index) {
                    return Divider(height: 0,indent: 15,endIndent: 15);
                },
                key: widget.key,
            )
        );
    }

    /// Get the total count of items in list(including both row and sections)
    int _listItemCount() {
        this._itemList = new List<int>.empty(growable: true);
        int rowCount = 0;
        for (int i = 0; i < this._sectionCount; i++) {
            int rows = widget.numberOfRowsInSection(i);
            rowCount += rows + 1;
            this._itemList.insert(i, rowCount);
        }
        return rowCount;
    }

    Widget _buildItemWidget(int index) {
        Color sectionColor = Colors.grey[200];
        Widget result = SizedBox(height: 0);
        IndexPath indexPath = _sectionModel(index);
        if (indexPath.row < 0) {
            if (widget.sectionWidget != null) {
                result = widget.sectionWidget(indexPath.section);
            }
        } else {
            return widget.rowWidget(indexPath.section, indexPath.row);
        }
        return Container(
            constraints: BoxConstraints.expand(height: 55),
            child: result,
            color: sectionColor,
        );
    }

    IndexPath _sectionModel(int index) {
        int row = 0;
        int section = 0;

        for (int i = 0; i < this._sectionCount; i++) {
            int item = this._itemList[i];
            if (index < item) {
                row = index - (i > 0 ? this._itemList[i - 1] : 0) - 1;
                section = i;
                break;
            }
        }
        return IndexPath(section: section, row: row);
    }
    int _rowIndex(IndexPath sectionModel) {
        int result = 0;
        for (int section = 0; section < sectionModel.section; section ++) {
            result += widget.numberOfRowsInSection(section);
        }
        return result + sectionModel.row;
    }
}

