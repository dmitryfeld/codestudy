import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:landmarks/AAS/Login.dart';
import 'package:landmarks/AAS/Signon.dart';
import 'package:landmarks/AAS/ProfileCreate.dart';
import 'package:landmarks/AAS/VeryfyEmail.dart';
import 'package:landmarks/MainController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:landmarks/Model/AAS/Contact.dart';
import 'package:landmarks/Model/AAS/Credentials.dart';
import 'package:landmarks/Model/AAS/Person.dart';
import 'package:landmarks/Model/AAS/Profile.dart';


import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

void main() {
    runApp(
        MyApp()
    );
}

class MyApp extends StatelessWidget {
      // This widget is the root of your application.
    @override Widget build(BuildContext context) {
        final Future<DataModel> _dataModel = Environment.initializeDataModel();
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
        ]);

        return MaterialApp(
            title: 'Landmark Guide',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: FutureBuilder(
                // Initialize FlutterFire:
                future: _dataModel,
                builder: (BuildContext contextP, AsyncSnapshot snapshotP) {
                    // Check for errors
                    if (snapshotP.hasError) {
                        return this._buildWarning(context,true,'Failure to load Firebase');
                    }
                    // Once complete, show your application
                    if (snapshotP.connectionState == ConnectionState.done) {
                        //final email = FirebaseAuth.instance.currentUser.email;

                        return this._prepareMainController(context, snapshotP.data as DataModel);
                        //MainController
                    }
                    // Otherwise, show something whilst waiting for initialization to complete
                    return this._buildWarning(context,false,'Firebase is loading');
                },
            )
        );
    }
    Widget _buildWarning(BuildContext context,bool isError,String content) {
        TextStyle warningStyle = Theme.of(context).textTheme.headline5.apply(color: Colors.black,fontSizeFactor: 1,fontWeightDelta:0);
        TextStyle errorStyle = Theme.of(context).textTheme.headline5.apply(color: Colors.red,fontSizeFactor: 1,fontWeightDelta:0);
        return Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration (
                color: Colors.white,
                border: Border.all(
                    color: Colors.black,
                    width: 2,
                    style: BorderStyle.solid
                )
            ),
            child: Center (
                child: Container(
                    constraints: BoxConstraints.expand(width: 200,height: 100),
                    margin: EdgeInsets.all(10),
                    child: Text(
                        content,
                        style: isError? errorStyle : warningStyle
                    )
                )
            )
        );
    }


    Widget _prepareLoginController(BuildContext context) {
        return LoginController(
            credentials: Credentials(
                email:'dima@feld.co',
                password:'zh0ppa123'
            )
        );
    }
    Widget _prepareSignonController(BuildContext context) {
        return SignonController(
            credentials: Credentials(
                email:'dima@feld.co',
                password:'zh0ppa123'
            )
        );
    }
    Widget _prepareUserInfoController(BuildContext context) {
        return ProfileCreateController(
            profile: Profile (
                person: Person(
                    firstName: 'Manana',
                    lastName: 'Kalapoozee'
                ),
                contact: Contact (
                    email: 'manana@kalapoozee.org',
                    phone: '+13332221122'
                ),
                address: Address (
                    number: '1855',
                    street: 'Jane Way',
                    unit: 'Apt 343',
                    city: 'Santa Clara',
                    state: 'California',
                    zipCode: '95126',
                    country: 'USA'
                )
            )
        );
    }

    Widget _prepareMainController(BuildContext context, DataModel model) {
        User user = FirebaseAuth.instance.currentUser;
        if (user == null) {
            return this._prepareSignonController(context);
        } else {
            FirebaseAuth.instance.currentUser.getIdTokenResult(true).then((value){
                IdTokenResult result = value as IdTokenResult;
            });
            return this._prepareLoginController(context);
            // try {
            //     FirebaseAuth.instance.signOut().then((value){
            //         print('signed out');
            //         user.delete().then((value){
            //           print('user deleted');
            //         });
            //     });
            // } on FirebaseAuthException catch(exceptionP) {
            //     print(exceptionP);
            // }  catch(exceptionPP) {
            //     print(exceptionPP);
            // }

            return this._buildWarning(context,false,'Unrealized state');
        }
    }

    Widget _prepareWaitVerify(BuildContext context) {
        return VerifyEmeinController();
    }
}