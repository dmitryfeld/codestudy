import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';


typedef void OnChangeValue(bool valueP);

@immutable class FavoriteButton extends StatefulWidget {
    final bool value;
    final OnChangeValue onChangeValue;
    FavoriteButton({this.value,this.onChangeValue,Key key}):
        assert(value != null,'State can not be null'),
        assert(onChangeValue != null,'OnChangeValue can not be null'),
        super(key: key);

    @override FavoriteButtonState createState() {
      return FavoriteButtonState();
    }
}

class  FavoriteButtonState extends State<FavoriteButton> {
    final filledStar = Icon(
        Icons.star,
        size: 30,
        color: Colors.orangeAccent,
    );
    final emptyStar = Icon(
        Icons.star_border,
        size: 30,
        color: Colors.orangeAccent,
    );
    @override Widget build(BuildContext context) {
        return Container(
            child: Material(
                child:IconButton(
                    onPressed: () {
                        setState(() {
                            widget.onChangeValue(!widget.value);
                        });
                    },
                    padding: EdgeInsets.all(0.0),
                    icon: widget.value ? this.filledStar : this.emptyStar,
                )
            )
        );
    }
}
