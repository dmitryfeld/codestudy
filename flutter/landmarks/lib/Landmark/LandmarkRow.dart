import 'package:flutter/material.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

typedef void OnLandmarkRowTapped(Landmark landmark);

@immutable class LandmarkRow extends StatelessWidget {
    final Landmark landmark;
    final OnLandmarkRowTapped onLandmarkRowTapped;

    const LandmarkRow({this.landmark,Key key,@required this.onLandmarkRowTapped}):
        assert(landmark != null,'Landmark can not be null'),
        assert(onLandmarkRowTapped != null,'OnLandmarkRowTapped can not be null'),
        super(key: key);

    @override Widget build(BuildContext context) {
        return _buildListItem(context);
    }
    Widget _buildListItem(BuildContext context) {
        Row icons = Row(children: this._buildIcons(context));
        return ListTile(
            leading: Image(
                image: AssetImage(this.landmark.imageName)
            ),
            title: Text(
                this.landmark.name,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis
            ),
            trailing: Container(
                width: 60,
                child: icons
            ),
            onTap: () {
                this.onLandmarkRowTapped(this.landmark);
            },
        );
    }
    List<Widget> _buildIcons(BuildContext context) {
        List<Widget> results = List<Widget>.empty(growable: true);
        if (this.landmark.isFavorite) {
            results.add(
                Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                        Icons.star,
                        size: 30,
                        color: Colors.orangeAccent,
                    )
                )
            );
        } else {
            results.add(
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 30
                    )
                )
            );
        }
        results.add(
            Align(
                alignment: Alignment.centerRight,
                child: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.grey,
                )
            )
        );
        return results;
    }
}
