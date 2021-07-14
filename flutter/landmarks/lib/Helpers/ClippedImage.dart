import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

@immutable class ClippedImage extends StatelessWidget {
    final ImageProvider image;

    const ClippedImage(this.image,{Key key}):super(key: key);

    @override Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: this.image,
                  fit: BoxFit.cover,
                )
            )
        );
    }
}

class ClippedImagePreview extends State {
    int _counter = 0;
    DataModel _dataModel;
    ImageProvider _image;
    @override void initState() {
        super.initState();
    }
    void _incrementCounter() {
        setState(() {
            if (_counter < Environment.model.landmarks.length - 1) {
                _counter++;
            }
        });
    }
    @override Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: (_dataModel != null) ? Text(_dataModel.landmarks[_counter].name) : Text('Testing Circular Imatge'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            padding: EdgeInsets.only(right: 0,left: 0),
                            constraints: BoxConstraints.expand(height: 220),
                            child: (_dataModel != null) ? ClippedImage(
                                AssetImage(_dataModel.landmarks[_counter].imageName)
                            ): Text('No Landmark Defined')
                        )
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
        );
    }
}
