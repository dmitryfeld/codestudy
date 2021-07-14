import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:landmarks/Category/CategoryItem.dart';
import 'package:landmarks/Model/CategoriesAndFeatures.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Category/CategoryRow.dart';
import 'package:landmarks/Landmark/LandmarkDetail.dart';
import 'package:landmarks/Featured/FeaturedPages.dart';
import 'package:landmarks/Profile/UserProfile.dart';

@immutable class CategoryHome extends StatefulWidget {
    final CategoriesAndFeatures categoriesAndFeatures;
    final OnCategoryItemTapped onCategoryItemTapped;
    final OnPageChanged onPageChanged;
    final int featuredPageIndex;

    CategoryHome({@required this.categoriesAndFeatures, @required this.onCategoryItemTapped, @required this.onPageChanged, this.featuredPageIndex = 0, Key key}):
        assert(categoriesAndFeatures != null, 'CategoriesAndFeatures can not be null'),
        assert(onCategoryItemTapped != null, 'OnCategoryItemTapped can not be null'),
        assert(onPageChanged != null, 'OnPageChanged can not be null'),
        super(key: key);

    @override CategoryHomeState createState() {
        return CategoryHomeState();
    }
}
class CategoryHomeState extends State<CategoryHome> {
    int _featuredPageIndex;

    @override void initState() {
        super.initState();
        this._featuredPageIndex = widget.featuredPageIndex;
    }

    @override Widget build(BuildContext context) {
        Iterable<String> categoryNames = widget.categoriesAndFeatures.categories.keys;
        List<Widget> widgets = List<Widget>.empty(growable: true);
        widgets.add(
            FeaturedPages(
                landmarks: widget.categoriesAndFeatures.features,
                selection: this._featuredPageIndex,
                onPageChanged: (int selectionP) {
                    setState(() {
                        widget.onPageChanged(this._featuredPageIndex = selectionP);
                    });
                }
            )
        );
        for(String categoryName in categoryNames) {
            widgets.add(this._createCategoryRow(context, categoryName));
        }
        return Align(
            alignment:Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(
                    children: widgets
                )
            )
        );
    }
    Widget _createCategoryRow(BuildContext context,String key) {
        List<Landmark> landmarks = widget.categoriesAndFeatures.categories[key];
        TextStyle style = Theme.of(context).textTheme.headline4;//.apply(color: Colors.black,fontWeightDelta: 3,fontSizeFactor:0.75);
        return Column(
            children: [
                CategoryRow(
                    landmarkList: landmarks,
                    categoryName: key,
                    onCategoryItemTapped: widget.onCategoryItemTapped,
                ),
                Divider()
            ],
        );
    }
}

class CategoryHomeController extends StatefulWidget {
    final CategoriesAndFeatures categoriesAndFeatures;

    const CategoryHomeController(this.categoriesAndFeatures,{Key key}) : super(key: key);

    @override CategoryHomeControllerState createState() {
        return CategoryHomeControllerState();
    }
}

class CategoryHomeControllerState extends State<CategoryHomeController> {
    @override void initState() {
        super.initState();
    }
    @override Widget build(BuildContext context) {
        return this._buildScaffold(context);
    }
    Widget _buildScaffold(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Featured'),
                actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                            onTap: this.onProfileTapped,
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
        if (widget.categoriesAndFeatures != null) {
            result = CategoryHome(
                categoriesAndFeatures: widget.categoriesAndFeatures,
                onCategoryItemTapped: this.onCategoryItemTapped
            );
        }
        return result;
    }
    void onCategoryItemTapped(Landmark landmarkP) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return LandmarkDetailController(landmarkP);
            }
        );
        Navigator.push(this.context, route).then((value) {
            // setState(() {
            //     _showFavoritesOnly = landmarkList.showFavoritesOnly;
            // });
        });
    }
    void onProfileTapped() {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return UserProfileController(profile: Environment.model.profile);
            }
        );
        Navigator.push(this.context, route).then((value) {

        });
    }
}
