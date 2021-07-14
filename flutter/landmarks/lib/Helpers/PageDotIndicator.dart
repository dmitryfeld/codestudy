import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

typedef OnPageDotIndicatorTapped(int indexP);

@immutable class PageDotIndicator extends StatelessWidget {
    final bool active;
    final int index;
    final OnPageDotIndicatorTapped onPageDotIndicatorTapped;

    const PageDotIndicator({@required this.active,@required this.index,@required this.onPageDotIndicatorTapped,Key key}):
        assert(active != null,'Active can not be null'),
        assert(index != null,'Index can not be null'),
        assert(onPageDotIndicatorTapped != null,'OnPageDotIndicatorTapped can not be null'),
        super(key: key);

    @override Widget build(BuildContext context) {
        return Container(
            width: 25,
            height: 25,
            child: GestureDetector(
                onTap: () {
                    if (null != this.onPageDotIndicatorTapped) {
                        this.onPageDotIndicatorTapped(this.index);
                    }
                },
                child: Image(
                    image: AssetImage(
                        active? 'assets/images/circleBlue.png' : 'assets/images/circleGrey.png'
                    )
                )
            )

        );
    }
}