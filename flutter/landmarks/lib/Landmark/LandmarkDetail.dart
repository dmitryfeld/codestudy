import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Helpers/CircleImage.dart';
import 'package:landmarks/Helpers/FavoriteButton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:landmarks/Profile/UserProfile.dart';

class LandmarkDetail extends StatefulWidget {
    final Landmark landmark;

    CameraPosition get cameraPosition {
        return CameraPosition(
            target: landmark.coordinates,
            zoom: 12.4766
        );
    }

    LandmarkDetail(this.landmark, {Key key}) :
        assert(landmark != null, 'Landmark List can not be null'),
        super(key: key);

    @override LandmarkDetailState createState() {
        return LandmarkDetailState();
    }
}

class LandmarkDetailState extends State<LandmarkDetail> {

    static final Completer<GoogleMapController> completer = Completer<GoogleMapController>();

    @override intState() {
        super.initState();
        this._updateCameraPosition();
    }

    @override Widget build(BuildContext context) {
        return Align(
            alignment:Alignment.topCenter,
            child: SingleChildScrollView(
                child: Stack(
                    children: [
                        Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                this._buildMap(context),
                                Container(
                                    constraints:BoxConstraints.expand(height: 130),
                                ),
                                this._buildNameBand(context),
                                this._buildParkNameBand(context),
                                Divider(),
                                this._buildAboutNameBand(context),
                                this._buildDescriptionBlock(context)
                            ]
                            //padding:EdgeInsets.only(top:10,bottom:10),
                            //child: Text('Kino Vino & Domino!!!' + landmark.name)
                        ),
                        Center(
                            child: CircleImage(
                                Image(image: AssetImage(widget.landmark.imageName)),
                                size: 260,
                                margin: EdgeInsets.only(top: 170)
                            )
                        )
                    ],
                )
        ));
    }
    Widget _buildMap(BuildContext context) {
        Set<Factory<OneSequenceGestureRecognizer>> recognizers = <Factory<OneSequenceGestureRecognizer>>[
            new Factory<OneSequenceGestureRecognizer>((){return EagerGestureRecognizer();})
        ].toSet();

        GoogleMap map = GoogleMap(
            gestureRecognizers: recognizers,
            mapType: MapType.normal,
            initialCameraPosition: widget.cameraPosition
        );
        return Container(
            //alignment: Alignment.topCenter,
            constraints:BoxConstraints.expand(height: 300),
            color: Colors.red,
            child: map
        );
    }
    Widget _buildNameBand(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline4.apply(color: Colors.black,fontWeightDelta: 1,fontSizeFactor:0.75);
        return Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
                children: [
                    Text(
                        widget.landmark.name,
                        style: style
                    ),
                    FavoriteButton(
                        value:widget.landmark.isFavorite,
                        onChangeValue: (bool valueP){
                            setState(() {
                                widget.landmark.isFavorite = valueP;
                            });
                        }
                    )
                ],
            ),
        );
    }
    Widget _buildParkNameBand(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontSizeFactor: 0.9,fontWeightDelta:-1);
        return Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: Row(
              children: [
                Expanded (
                    child: Text(
                        widget.landmark.park,
                        style: style,
                        overflow: TextOverflow.ellipsis
                    )
                ),
                Container(
                    child:
                    Text(
                        widget.landmark.state,
                        style: style
                    )
                )
              ],
            )
        );
    }
    Widget _buildAboutNameBand(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline4.apply(color: Colors.black,fontWeightDelta: 0,fontSizeFactor:0.7);
        return Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            alignment: Alignment.centerLeft,
            child: Text(
                'About ' + widget.landmark.name,
                style: style
            )
        );
    }

    Widget _buildDescriptionBlock(BuildContext context) {
        TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.black,fontWeightDelta: -1,fontSizeFactor:0.9);
        return Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
                widget.landmark.description,
                style: style
            )
        );
    }

    void _updateCameraPosition() {
        LandmarkDetailState.completer.future.then((controller) {
            controller.moveCamera(CameraUpdate.newCameraPosition(widget.cameraPosition));
        });
    }
}

class LandmarkDetailController extends StatelessWidget {
    final Landmark landmark;
    const LandmarkDetailController(this.landmark,{Key key}):super(key: key);
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(this.landmark.name),
                actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                            onTap: () {
                                this.onProfileTapped(context);
                            },
                            child: Icon(
                                Icons.account_circle
                            ),
                        )
                    ),
                ],
            ),
            body: Center(
                child: LandmarkDetail(this.landmark)
            )
        );
    }

    void onProfileTapped(BuildContext context) {
      MaterialPageRoute route = MaterialPageRoute(
          builder: (context){
            return UserProfileController(profile: Environment.model.profile);
          }
      );
      Navigator.push(context, route).then((value) {

      });
    }
}

