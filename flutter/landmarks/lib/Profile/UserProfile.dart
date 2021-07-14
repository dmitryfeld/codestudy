import 'package:flutter/material.dart';
import 'package:landmarks/Helpers/AAS/ContactForm.dart';
import 'package:landmarks/Helpers/AAS/PersonForm.dart';
import 'package:landmarks/Helpers/AAS/AddressForm.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:landmarks/Model/AAS/Contact.dart';
import 'package:landmarks/Model/AAS/Person.dart';
import 'package:landmarks/Model/AAS/Profile.dart';


// Create a Form widget.
@immutable class UserProfile extends StatefulWidget {
    final Profile profile;

    const UserProfile({this.profile,Key key}):
        assert(profile != null,'Participant can not be null'),
        super(key: key);

    @override UserProfileState createState() {
        return UserProfileState();
    }
}
class UserProfileState extends State<UserProfile> {
    final _formKey = GlobalKey<FormState>();

    @override void initState() {
    // TODO: implement initState
        super.initState();
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
                        ],
                    )
                )
            )
        );
    }
    Widget _buildPersonForm(BuildContext context) {
        return PersonForm (
            person: widget.profile == null ? null : widget.profile.person,
            readOnly: true,
        );
    }
    Widget _buildContactForm(BuildContext context) {
        return ContactForm (
            contact: widget.profile == null ? null : widget.profile.contact,
            readOnly: true,
        );
    }
    Widget _buildAddressForm(BuildContext context) {
        return AddressForm (
            address: widget.profile == null ? null : widget.profile.address,
            readOnly: true
        );
    }
}

class UserProfileController extends StatefulWidget {
    final Profile profile;
    const UserProfileController({this.profile,Key key}) :
          super(key: key);

    @override UserProfileControllerState createState() {
        return UserProfileControllerState();
    }
}

class UserProfileControllerState extends State<UserProfileController> {
    Profile _profile;

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
            child: UserProfile(
                profile: this._profile
            )
        );
    }
}

