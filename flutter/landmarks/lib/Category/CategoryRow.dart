import 'package:flutter/material.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Category/CategoryItem.dart';

@immutable class CategoryRow extends StatelessWidget {
    final String categoryName;
    final List<Landmark> landmarkList;
    final OnCategoryItemTapped onCategoryItemTapped;

    CategoryRow({@required this.landmarkList,@required this.onCategoryItemTapped,this.categoryName,Key key}):
        assert(landmarkList != null, 'Landmark List can not be null'),
        assert(onCategoryItemTapped != null, 'OnCategoryItemTapped List can not be null'),
        super(key: key);

    List<Landmark> actualList() {
        return this.landmarkList.where((element){
            if (this.categoryName == null) {
                return true;
            }
            return element.category == this.categoryName;
        }).toList();
    }

    @override Widget build(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline4.apply(color: Colors.black,fontWeightDelta: 1,fontSizeFactor:0.65);
        String title = "All";
        if (this.categoryName != null) {
            title = this.categoryName;
        }
        return Container(
            constraints:BoxConstraints.expand(height: 205),
            //color: Colors.green,
            child: Column (
                children: [
                    Container(
                        constraints:BoxConstraints.expand(height: 30),
                        //color: Colors.red,
                        alignment: Alignment.topLeft,
                        child: Text(title,style: style,),
                        padding: EdgeInsets.only(left: 15, top: 0),
                    ),

                    this._buildRow(context)
                ],
            )
        );
    }

    Widget _buildRow(BuildContext context) {
        List<Widget> items = List<Widget>.empty(growable: true);
        CategoryItem temp = null;
        for (Landmark landmark in this.actualList()) {
            temp = CategoryItem(
                landmark:landmark,
                onCategoryItemTapped:this.onCategoryItemTapped
            );
            items.add(temp);
        }
        return Align(
            alignment:Alignment.topCenter,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: items,
                )
            )
        );
    }
}

