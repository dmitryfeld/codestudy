import 'package:flutter/material.dart';
import 'package:landmarks/Category/CategoryHome.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:landmarks/Landmark/LandmarkList.dart';
import 'package:landmarks/Landmark/LandmarkDetail.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Profile/UserProfile.dart';



class MainController extends StatefulWidget {
    final DataModel dataModel;
    MainController({@required this.dataModel,Key key}) :
        assert(dataModel != null,'Data Model Can not be null'),
        super(key: key);

    @override MainControllerState createState() {
        return MainControllerState();
    }
}


class MainControllerState extends State<MainController> {
    int _selectedController;
    bool _showFavoritesOnly = false;
    int _featuredPageIndex = 0;

    @override void initState() {
        super.initState();
        _selectedController = 0;
        _showFavoritesOnly = false;
        _featuredPageIndex = 0;
    }

    @override Widget build(BuildContext context) {
      return this._buildScaffold(context);
    }

    CategoryHome _category;
    LandmarkList _landmark;

    Widget _buildBody(BuildContext context) {
        Widget result = Text('NO LANDMARKS');

        if (0 == _selectedController) {
            result = _category = CategoryHome(
                categoriesAndFeatures:widget.dataModel.categoriesAndFeatures,
                featuredPageIndex: this._featuredPageIndex,
                onCategoryItemTapped: onCategoryItemTapped,
                onPageChanged: (int selectionP){
                    this._featuredPageIndex = selectionP;
                },
            );
        } else {
            result = _landmark = LandmarkList(
                landmarkList: widget.dataModel.landmarks,
                onSelectoinChanged: this.onSelectoinChanged,
                onShowsFavoritesOnlyChanged: (bool showFavoritesOnlyP) {
                    setState(() {
                        this._showFavoritesOnly = showFavoritesOnlyP;
                    });
                },
                showFavoritesOnly: _showFavoritesOnly,
            );
        }

        return result;
    }

    Widget _buildScaffold(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: _selectedController == 0 ? Text('Featured') : Text('Landmarks'),
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
            body: Center(
                child:this._buildBody(context)
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: (int selectionP){
                    setState(() {
                        _selectedController = selectionP;
                        if (_landmark != null) {
                            //_showFavoritesOnly = _landmark.showFavoritesOnly;
                        }
                        if (_category != null) {
                            //_featuredPageIndex = _category.futuredPageIndex;
                        }
                    });
                }, // this will be set when a new tab is tapped
                items: [
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.star_border),label:'Featured'),
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.list),label:'List')
                ],
                currentIndex: _selectedController != null ? _selectedController : 0,
            )
        );
    }
    void onCategoryItemTapped(Landmark landmarkP) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return LandmarkDetailController(landmarkP);
            }
        );
        Navigator.push(this.context, route).then((value) {

        });
    }
    void onSelectoinChanged(Landmark selectionP) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
              return LandmarkDetailController(selectionP);
            }
        );
        Navigator.push(this.context, route).then((value) {
            setState(() {
                //this._showFavoritesOnly = showFavoritesOnlyP;
            });
        });
    }
    void onProfileTapped() {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return UserProfileController(profile: widget.dataModel.participant);
            }
        );
        Navigator.push(this.context, route).then((value) {

        });
    }
}