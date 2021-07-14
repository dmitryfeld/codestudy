import 'package:flutter/material.dart';

@immutable class CircleImage extends StatelessWidget {
    final Image image;
    final double size;
    final EdgeInsets margin;

    const CircleImage(this.image,{Key key,this.size = 100,this.margin}) :
        assert(image != null,'Image can not be Null'),
        super(key: key);

    @override Widget build(BuildContext context) {
        return Container(
            constraints:BoxConstraints.tight(Size(this.size,this.size)),
            margin: this.margin != null ? this.margin : EdgeInsets.all(0),
            child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: this.image
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.all(Radius.circular(130)),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                    ),
                ],
            )
        );
    }
}


