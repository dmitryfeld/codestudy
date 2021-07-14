import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Helpers/ClippedImage.dart';
import 'package:landmarks/Helpers/PageDotIndicator.dart';

typedef OnPageChanged (int selectionP);

@immutable class FeaturedPages extends StatefulWidget {
    final List<Landmark> landmarks;
    final OnPageChanged onPageChanged;
    final int selection;

    const FeaturedPages({@required this.landmarks,@required this.onPageChanged,@required this.selection=0,Key key}) :
        assert(landmarks != null,'Landmarks can not be null'),
        assert(onPageChanged != null,'OnPageChanged can not be null'),
        assert(selection != null,'Selection can not be null'),
        super(key: key);

    @override FeaturedPagesState createState() {
        return FeaturedPagesState();
    }
}

class FeaturedPagesState extends State<FeaturedPages> {
    int _selection;
    PageController _pageController;

    @override void initState() {
        super.initState();
        _pageController = PageController(initialPage: this._selection = widget.selection);
    }

    @override Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: [
                    //this._buildSelectedFeaturedItemName(context),
                    this._buildFeaturedItemsPage(context)
                ],
            ),
        );
    }
    Widget _buildFeaturedItemsPage(BuildContext context) {
        return Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children:[
                this._buildFeaturedItemsPageView(context),
                this._buildSelectedFeaturedItemName(context),
                this._buildListOfFeaturedItemsPageIndicators(context)
            ],
        );
    }
    Widget _buildSelectedFeaturedItemName(BuildContext context) {
        TextStyle style1 = Theme.of(context).textTheme.headline5.apply(color: Colors.white,fontWeightDelta: 2,fontSizeFactor:.9);
        TextStyle style2 = Theme.of(context).textTheme.headline6.apply(color: Colors.white,fontWeightDelta: 0,fontSizeFactor:1,fontStyle: FontStyle.italic);
        return Container(
            constraints: BoxConstraints.expand(height: 75),
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(bottom: 20),
            child: Column (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text (
                        widget.landmarks[this._selection].name,
                        style: style1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis
                    ),
                    Text (
                        widget.landmarks[this._selection].park,
                        style: style2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis
                    )
                ],
            )
        );
    }
    Widget _buildFeaturedItemsPageView(BuildContext context) {
        return Container(
            constraints: BoxConstraints.expand(height: 250),
            child:PageView(
                scrollDirection: Axis.horizontal,
                controller: this._pageController,
                children: this._buildListOfFeaturedItemsPages(context),
                onPageChanged: (int selectionP) {
                    this.setState(() {
                        widget.onPageChanged(this._selection = selectionP);
                    });
                },
            )
        );
    }
    List<Widget> _buildListOfFeaturedItemsPages(BuildContext context) {
        List<Widget> result = List<Widget>.empty(growable: true);
        Widget temp;
        for (Landmark landmark in widget.landmarks) {
            temp = Center (
                child: ClippedImage(
                    AssetImage(landmark.imageName)
                )
            );
            result.add(temp);
        }
        return result;
    }
    Widget _buildListOfFeaturedItemsPageIndicators(BuildContext context) {
        double len = 40.0 * widget.landmarks.length;
        List<Widget> children = List<Widget>.empty(growable: true);
        Widget temp;
        int count = 0;
        for (Landmark landmark in widget.landmarks) {
            temp = PageDotIndicator(
                active: count == this._selection,
                index: count,
                onPageDotIndicatorTapped: (indexP){
                    if (this._pageController != null) {
                        this._pageController.animateToPage(
                            this._selection = indexP,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut
                        );
                    }
                }
            );
            children.add(Spacer());
            children.add(temp);
            children.add(Spacer());
            count ++;
        }
        return Container(
            constraints: BoxConstraints.expand(width:len, height: 15),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(bottom:20),
            child: Row(
                children: children
            )
        );
    }

}
