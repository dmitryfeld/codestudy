import 'package:flutter/material.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Landmark/LandmarkRow.dart';
import 'package:landmarks/Landmark/LandmarkDetail.dart';

typedef void OnSelectionChanged(Landmark selectionP);
typedef void OnShowsFavoritesOnlyChanged(bool showFavoritesOnlyP);

@immutable class LandmarkList extends StatefulWidget {
    final List<Landmark> landmarkList;
    final OnSelectionChanged onSelectoinChanged;
    final OnShowsFavoritesOnlyChanged onShowsFavoritesOnlyChanged;
    final bool showFavoritesOnly;

    const LandmarkList({
        @required this.landmarkList,
        @required this.onSelectoinChanged,
        @required this.onShowsFavoritesOnlyChanged,
        this.showFavoritesOnly = false,
        Key key
    }): assert(landmarkList != null,'Landmark List can not be null'),
        assert(onSelectoinChanged != null,'OnSelectoinChanged List can not be null'),
        assert(onShowsFavoritesOnlyChanged != null,'OnShowsFavoritesOnlyChanged List can not be null'),
        super(key: key);

    @override LandmarkListState createState() {
        return LandmarkListState();
    }
}
class LandmarkListState extends State<LandmarkList> {
    @protected bool _showFavoritesOnly;

    List<Landmark> actualList() {
        return widget.landmarkList.where((element){
            return element.isFavorite || !widget.showFavoritesOnly;
        }).toList();
    }
    @override initState() {
        super.initState();
        this._showFavoritesOnly = widget.showFavoritesOnly;
    }
    @override Widget build(BuildContext context) {
        return Container(
            //alignment: Alignment.centerRight,
            //padding: EdgeInsets.only(top:0,bottom:0),
            child: Column(
                children: [
                    Container(
                        padding: EdgeInsets.only(right: 0,left: 15),
                        child: this._buildHeader(context)
                    ),
                    Divider(),
                    Expanded(
                        child: this._buildList(context)
                    )
                ],
            )
        );
    }
    Widget _buildList(BuildContext context) {
        List<Landmark> landmarks = this.actualList();
        return ListView.separated(
            itemCount:landmarks.length,
            separatorBuilder: (context,index) {
                return Divider();
            },
            itemBuilder: (context, index) {
                return LandmarkRow(
                    landmark: landmarks[index],
                    onLandmarkRowTapped: (Landmark landmarkP){
                        if (widget.onSelectoinChanged != null) {
                            widget.onSelectoinChanged(landmarkP);
                        }
                    }
                );
            }
        );
    }
    Widget _buildHeader(BuildContext context) {
        return Row(
            children: [
                Expanded (
                    child: Text(
                        'Favorites Only',
                        style: Theme.of(context).textTheme.headline6
                    ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                        value: widget.showFavoritesOnly,
                        onChanged: (valueChanged) {
                            setState(() {
                                this._showFavoritesOnly = valueChanged;
                                if (widget.onShowsFavoritesOnlyChanged != null) {
                                    widget.onShowsFavoritesOnlyChanged(valueChanged);
                                }
                            });
                        }
                    )
                )
            ]
        );
    }
}

class LandmarkListController extends StatefulWidget {
    final DataModel dataModel;
    final bool showFavoritesOnly;

    const LandmarkListController(this.dataModel,{Key key,this.showFavoritesOnly = false}) : super(key: key);

    @override LandmarkListControllerState createState() {
        return LandmarkListControllerState();
    }
}


class LandmarkListControllerState extends State<LandmarkListController> {
    bool _showFavoritesOnly = false;

    @override void initState() {
        super.initState();
        _showFavoritesOnly = widget.showFavoritesOnly;
    }
    @override Widget build(BuildContext context) {
        return _buildScaffold(context);
    }
    Widget _buildScaffold(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Landmarks'),
                actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                                Icons.account_circle
                            ),
                        )
                    ),
                ],
            ),
            body: Align(
                alignment:Alignment.topCenter ,
                child: this._buildContent(context),
            )
        );
    }
    Widget _buildContent(BuildContext context) {
        Widget result = Text('No Landmark Defined');
        if (widget.dataModel != null) {
            result = LandmarkList(
                landmarkList: widget.dataModel.landmarks,
                onSelectoinChanged: this.onSelectoinChanged,
                onShowsFavoritesOnlyChanged: this.onShowsFavoritesOnlyChanged,
                showFavoritesOnly: widget.showFavoritesOnly
            );
        }
        return result;
    }

    void onSelectoinChanged(Landmark selectionP) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return LandmarkDetailController(selectionP);
            }
        );
        Navigator.push(this.context, route).then((value) {
            setState(() {
                //this._showFavoritesOnly = showsFavoritesOnlyP;
            });
        });
    }

    void onShowsFavoritesOnlyChanged(showFavoritesOnlyP) {
        setState(() {
            this._showFavoritesOnly = showFavoritesOnlyP;
        });
    }
}

