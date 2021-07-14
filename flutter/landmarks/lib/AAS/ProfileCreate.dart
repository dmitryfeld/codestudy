
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:landmarks/Helpers/AAS/ContactForm.dart';
import 'package:landmarks/Helpers/AAS/PersonForm.dart';
import 'package:landmarks/Helpers/AAS/AddressForm.dart';
import 'package:landmarks/Helpers/Places/PlacesAPIProvider.dart';
import 'package:landmarks/MainController.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:landmarks/Model/AAS/Contact.dart';
import 'package:landmarks/Model/AAS/Person.dart';
import 'package:landmarks/Model/AAS/Profile.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:uuid/uuid.dart';

typedef OnSubmitProfileButtonPressed(Profile userP);

// Create a Form widget.
@immutable class ProfileCreate extends StatefulWidget {
    final OnSubmitProfileButtonPressed onSubmitProfileButtonPressed;
    final Profile profile;

    const ProfileCreate({@required this.onSubmitProfileButtonPressed,this.profile,Key key}):
        assert(onSubmitProfileButtonPressed != null,'OnUserInfoSubmitButtonPressed can not be null'),
        super(key: key);

    @override ProfileCreateState createState() {
        return ProfileCreateState();
    }
}
class ProfileCreateState extends State<ProfileCreate> {
    final _formKey = GlobalKey<FormState>();
    Person _person;
    Contact _contact;
    Address _address;

    @override void initState() {
    // TODO: implement initState
        super.initState();
        if (widget.profile != null) {
            this._address = widget.profile.address;
            this._person = widget.profile.person;
            this._contact = widget.profile.contact;
        }
    }
    @override Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80,horizontal: 30),
                child: Form (
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            this._buildPersonForm(context),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                //child: Divider(),
                            ),
                            this._buildContactForm(context),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                //child: Divider(),
                            ),
                            this._buildAddressForm(context),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Container(
                                    constraints: BoxConstraints.expand(height: 45),
                                    color: Colors.yellow,
                                    child: this._createSubmitButton(context)
                                )
                            )
                        ],
                    )
                )
            )
        );
    }
    Widget _buildPersonForm(BuildContext context) {
        return PersonForm (
            person: widget.profile == null ? null : widget.profile.person,
            onPersonFormEditingCompleted: (Person personP){
                if (this._formKey.currentState.validate()) {
                    this._person = personP;
                }
            },
            onPersonFormTextChanged:(Person personP){
                this._person = personP;
            }
        );
    }
    Widget _buildContactForm(BuildContext context) {
        return ContactForm (
            contact: widget.profile == null ? null : widget.profile.contact,
            onContactFormEditingCompleted: (Contact contactP) {
                if (this._formKey.currentState.validate()) {
                    this._contact = contactP;
                }
            },
            onContactFormTextChanged: (Contact contactP){
                this._contact = contactP;
            }
        );
    }
    Widget _buildAddressForm(BuildContext context) {
        return AddressForm (
            address: widget.profile == null ? null : widget.profile.address,
            onAddressFormEditingCompleted: (Address addressP){
                if (this._formKey.currentState.validate()) {
                    this._address = addressP;
                }
            },
            onAddressFormTextChanged: (Address addressP){
                this._address = addressP;
            },
        );
    }
    Widget _createSubmitButton(BuildContext context) {
        return ElevatedButton(
            onPressed: () {
                if (this._formKey.currentState.validate()) {
                    widget.onSubmitProfileButtonPressed(
                        Profile(
                            address: this._address,
                            person: this._person,
                            contact: this._contact
                        )
                    );
                }
            },
            child: Text('Submit')
        );
    }
}

class ProfileCreateController extends StatefulWidget {
    final Profile profile;
    const ProfileCreateController({this.profile,Key key}) :
        super(key: key);

    @override ProfileCreateControllerState createState() {
        return ProfileCreateControllerState();
    }
}

class ProfileCreateControllerState extends State<ProfileCreateController> {
    Profile _profile;
    PlacesAPIProvider _provider;

    @override void initState() {
        super.initState();
        this._profile = widget.profile;
    }
    @override Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Sign on'),
            ),
            body: this._buildBody(context)
        );
    }
    Widget _buildBody(BuildContext context) {
        return Align(
            alignment:Alignment.topCenter ,
            child: ProfileCreate(
                profile: this._profile,
                onSubmitProfileButtonPressed: this.submitProfile
            )
        );
    }

    void submitProfile(Profile profileP) async {
        this._proceedToMain(profileP);
        /*
        showAlertDialog(this.context,'Verifying mail address');
        this._createProvider(this.context).reverseGeo(profileP.address).then((value) {
            Navigator.pop(this.context);
            if (value == null) {
              this.showSnackbar(context,'Invalid address entered');
            } else {
                try {
                    this.showAlertDialog(this.context,'Submitting profile data');
                    Environment.updateParticipant(profileP).then((value){
                        Navigator.pop(this.context);
                        this._proceedToMain(profileP);
                    });
                } on FirebaseException catch(exceptionP) {
                    Navigator.pop(this.context);
                    this.showSnackbar(this.context, exceptionP.message);
                } catch(exceptionPP) {
                    Navigator.pop(this.context);
                    this.showSnackbar(this.context, 'HËX occurred');
                }
            }
        });
         */
    }

    void _proceedToMain(Profile profile) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return MainController(
                    dataModel: Environment.model,
                );
            }
        );
        Navigator.pushReplacement(this.context, route).then((value) {

        });
    }

    void showAlertDialog(BuildContext context,String message) {
        AlertDialog alert=AlertDialog(
            content: new Row(
                children: [
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)),
                    Container(margin: EdgeInsets.only(left: 15),child:Text(message)),
                ]
            )
        );
        showDialog(barrierDismissible: false,
            context:context,
            builder:(BuildContext context){
                return alert;
            }
        );
    }

    void showSnackbar(BuildContext context,String message) {
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Text(message),
            action: SnackBarAction(
                label: 'Done',
                onPressed: () {

                },
            ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    PlacesAPIProvider _createProvider(BuildContext context) {
        if (null == this._provider) {
            String sessionToken = Uuid().v4();
            String language = Localizations.localeOf(context).languageCode;
            String country = 'us';
            this._provider = PlacesAPIProvider(
                sessionToken: sessionToken,
                language: language,
                country: country
            );
        }
        return this._provider;
    }
}

