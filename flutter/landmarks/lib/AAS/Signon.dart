
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landmarks/AAS/ProfileCreate.dart';
import 'package:landmarks/AAS/VeryfyEmail.dart';
import 'package:landmarks/MainController.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:landmarks/Model/AAS/Contact.dart';
import 'package:landmarks/Model/AAS/Credentials.dart';
import 'package:landmarks/Model/AAS/Person.dart';
import 'package:landmarks/Model/AAS/Profile.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

typedef OnSignonSubmitButtonPressed(Credentials credentialsP);

// Create a Form widget.
@immutable class Signon extends StatefulWidget {
    final OnSignonSubmitButtonPressed onSignonSubmitButtonPressed;
    final Credentials credentials;
    final bool shallHidePassword;

    Signon({@required this.credentials,@required this.onSignonSubmitButtonPressed,this.shallHidePassword = true,Key key}):
        assert(credentials != null,'Credentials can not be null'),
        assert(onSignonSubmitButtonPressed != null,'OnSignonSubmitButtonPressed can not be null'),
        super(key: key);

    @override SignonState createState() {
        return SignonState();
    }
}
class SignonState extends State<Signon> {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    bool _shallHidePassword;

    @override void initState() {
        super.initState();
        if (widget.credentials != null) {
            this._emailController.text = widget.credentials.email;
            this._passwordController.text = widget.credentials.password;
            this._confirmPasswordController.text = widget.credentials.password;
        }
        this._shallHidePassword = widget.shallHidePassword;
    }
    @override Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 80,horizontal: 30),
                child: this._buildForm(context)
            )
        );
    }
    Widget _buildForm(BuildContext context) {
        // Build a Form widget using the _formKey created above.
       TextStyle style = Theme.of(context).textTheme.headline6.apply(color: Colors.grey,fontWeightDelta: -1,fontSizeFactor:0.75);
        return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    TextFormField(
                        // The validator receives the text that the user has entered.
                        decoration: InputDecoration(
                            hintText: 'joe@shmoe.com',
                            labelText: 'Email',
                            hintStyle: style
                        ),
                        controller: this._emailController,
                        //obscureText: true,
                        validator: (value) {
                            if (value == null || value.isEmpty && !Validator.validateEmail(value)) {
                                return 'Please enter valid email';
                            }
                            return null;
                        }
                    ),
                    TextFormField(
                        // The validator receives the text that the user has entered.
                        decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: this._createEyeButton(context)
                        ),
                        controller: this._passwordController,
                        obscureText: this._shallHidePassword,
                        validator: (value) {
                            if (value == null || value.isEmpty && !Validator.validatePassword(value)) {
                                return 'Please enter valid password';
                            }
                            if (value != this._confirmPasswordController.text) {
                                return 'Please confirm your password';
                            }
                            return null;
                        }
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                        decoration: InputDecoration(
                            labelText: 'Password Confirmation',
                            //suffixIcon: this._createEyeButton(context)
                        ),
                        controller: this._confirmPasswordController,
                        obscureText: this._shallHidePassword,
                        // validator: (value) {
                        //     if (value == null || value.isEmpty && !Validator.validatePassword(value)) {
                        //         return 'Please enter valid password';
                        //     }
                        //     if (value != this._passwordController.text) {
                        //         return 'Please correct your password';
                        //     }
                        //     return null;
                        // }
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Container(
                            constraints: BoxConstraints.expand(height: 45),
                            color: Colors.yellow,
                            child: this._createSubmitButton(context)
                        )
                    )
                ],
            ),
        );
    }
    Widget _createEyeButton(BuildContext context) {
        return IconButton (
            icon: Icon(
              this._shallHidePassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
              size: 25,
              color: Colors.grey,
            ),
            onPressed: () {
                setState(() {
                    this._shallHidePassword = !this._shallHidePassword;
                });
            },
        );
    }
    Widget _createSubmitButton(BuildContext context) {
        return ElevatedButton(
            onPressed: () {
                if (this._formKey.currentState.validate()) {
                    widget.onSignonSubmitButtonPressed(
                        Credentials(
                            email:this._emailController.text,
                            password:this._passwordController.text
                        )
                    );
                }
            },
            child: Text('Submit')
        );
    }
}

class SignonController extends StatefulWidget {
    final Credentials credentials;
    const SignonController({this.credentials,Key key}) : super(key: key);

    @override SignonControllerState createState() {
        return SignonControllerState();
    }
}

class SignonControllerState extends State<SignonController> {
    @override void initState() {
        super.initState();
    }
    @override Widget build(BuildContext context) {
        return this._buildScaffold(context);
    }
    Widget _buildScaffold(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Sign on'),
            ),
            body: Align(
              alignment:Alignment.topCenter ,
              child: Signon(
                  credentials: widget.credentials,
                  onSignonSubmitButtonPressed: this.onSignonSubmitButtonPressed
              ),
            )
        );
    }
    void onSignonSubmitButtonPressed(Credentials credentialsP) {
        this.navigateToUserInfo(this.context);
    }
    /*
    void onSignonSubmitButtonPressed(Credentials credentialsP) async {
        try {
            this.showAlertDialog(this.context);
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: credentialsP.email,
                password: credentialsP.password);
            Navigator.pop(this.context);
            
            if (!FirebaseAuth.instance.currentUser.emailVerified) {
                await FirebaseAuth.instance.currentUser.sendEmailVerification();
                this.navigateToWaitEmailVerification(this.context);
            } else {
                this.navigateToUserInfo(this.context);
            }

        } on FirebaseAuthException catch(exceptionP) {
            Navigator.pop(this.context);
            if (exceptionP.code == 'weak-password') {
                this.showSnackbar(this.context, 'The password provided is too weak.');
            } else if (exceptionP.code == 'email-already-in-use') {
                String email = credentialsP.email;
                this.showSnackbar(this.context, 'The account already exists for $email.');
            }
        } catch(exceptionPP) {
            Navigator.pop(this.context);
            this.showSnackbar(this.context, 'NËX ocurred');
        }
    }
     */
    
    void navigateToWaitEmailVerification(BuildContext context) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return VerifyEmeinController();
            }
        );
        Navigator.pushReplacement(this.context, route).then((value) {

        });
    }

    void navigateToUserInfo(BuildContext context) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
                return ProfileCreateController(profile: this.__simulatedProfile());
            }
        );
        Navigator.pushReplacement(this.context, route).then((value) {

        });
    }

    void showAlertDialog(BuildContext context) {
        AlertDialog alert=AlertDialog(
            content: new Row(
                children: [
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)),
                    Container(margin: EdgeInsets.only(left: 15),child:Text("Submitting..." )),
                ]
            )
        );
        showDialog(
            barrierDismissible: false,
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


    Profile __simulatedProfile() {
        return Profile (
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
        );
    }
}

