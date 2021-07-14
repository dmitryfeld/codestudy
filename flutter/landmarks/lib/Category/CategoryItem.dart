import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:landmarks/Model/Landmark.dart';

typedef void OnCategoryItemTapped(Landmark landmarkP);

@immutable class CategoryItem extends StatelessWidget {
    final Landmark landmark;
    final OnCategoryItemTapped onCategoryItemTapped;

    const CategoryItem({@required this.landmark,@required this.onCategoryItemTapped,Key key}):
        assert(landmark != null,'Landmark can not be null'),
        assert(onCategoryItemTapped != null,'OnCategoryItemTapped can not be null'),
        super(key: key);

    @override Widget build(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.black,fontWeightDelta: -1,fontSizeFactor:0.8);
        return GestureDetector(
            onTap: (){
                this.onCategoryItemTapped(this.landmark);
            },
            child: Container(
                constraints:BoxConstraints.expand(height: 175,width: 165),
                padding: EdgeInsets.only(left: 15),
                child: Column(
                    children: [
                        Container(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                                child:Image(
                                    image: AssetImage(this.landmark.imageName)
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)
                                )
                            ),
                        ),
                        Container(
                            width: 150,
                            height: 25,
                            //color: Colors.red,
                            alignment:Alignment.bottomLeft,
                            child: Text(
                                this.landmark.name,
                                style: style,
                                overflow: TextOverflow.ellipsis
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}
