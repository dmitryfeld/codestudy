
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landmarks/AAS/ProfileCreate.dart';
import 'package:landmarks/MainController.dart';
import 'package:landmarks/Model/AAS/Credentials.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';

//typedef OnVeryfyEmailSubmitButtonPressed(Credentials credentialsP);

// Create a Form widget.
class VeryfyEmail extends StatelessWidget {
    final Function onCheckButtonPressed;
    final Function onResendButtonPressed;
    VeryfyEmail({this.onCheckButtonPressed,this.onResendButtonPressed,Key key}): super(key: key);

    @override  Widget build(BuildContext context) {
        return Column(
            children: [
                Expanded(
                    flex: 2,
                    child: Container(),
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Column(
                            children: [
                                Container(
                                    constraints: BoxConstraints.expand(height: 30),
                                    //color:Colors.yellow,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Text(
                                                'Email verification send. Please take action.',
                                                style: Theme.of(context).textTheme.headline6.apply(fontSizeFactor:0.9,fontWeightDelta: -2),
                                            ),
                                        )
                                    )
                                ),
                                Container(height: 20,),
                                Container(
                                    constraints: BoxConstraints.expand(height: 35),
                                    //color: Colors.red,
                                    child: Center (
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                                children: [
                                                    ElevatedButton(onPressed: this.onCheckButtonPressed, child: Text('Check State')),
                                                    Container(width: 20),
                                                    ElevatedButton(onPressed: this.onResendButtonPressed, child: Text('Resend Email'))
                                                ],
                                            ),
                                        )
                                    )
                                )
                            ],
                        )
                    ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(),
                )
            ],
        );
    }
}


class VerifyEmeinController extends StatefulWidget {
    const VerifyEmeinController({Key key}) : super(key: key);

    @override VerifyEmeinControllerState createState() {
        return VerifyEmeinControllerState();
    }
}

class VerifyEmeinControllerState extends State<VerifyEmeinController> {
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
              child: VeryfyEmail(
                  onCheckButtonPressed: this.onCheckButtonPressed,
                  onResendButtonPressed: this.onResendButtonPressed,
              )
            )
        );
    }
    void onCheckButtonPressed() async {
        try {
            this.showAlertDialog(this.context, 'Checking');
            await FirebaseAuth.instance.currentUser.reload();
            Navigator.pop(this.context);
            if (FirebaseAuth.instance.currentUser.emailVerified) {
                this.navigateToUserInfo(this.context);
            } else {
                this.showSnackbar(this.context, 'Your email is not verified. Please verify your email');
            }
        } on FirebaseAuthException catch(exceptionP) {
            Navigator.pop(this.context);
            this.showSnackbar(this.context, exceptionP.message);
        } catch(exceptionPP) {
            Navigator.pop(this.context);
            this.showSnackbar(this.context, 'HËX occurred: ' + exceptionPP.toString());
        }
    }
    void onResendButtonPressed() async {
        try {
            this.showAlertDialog(this.context,'Resending verification email');
            await FirebaseAuth.instance.currentUser.sendEmailVerification();
            Navigator.pop(this.context);

        } on FirebaseAuthException catch(exceptionP) {
            Navigator.pop(this.context);
            this.showSnackbar(this.context,exceptionP.message);
        } catch(exceptionPP) {
            Navigator.pop(this.context);
            this.showSnackbar(this.context, 'NËX ocurred');
        }
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

    void navigateToUserInfo(BuildContext context) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (contextP){
                return ProfileCreateController();
            }
        );
        Navigator.pushReplacement(context, route).then((value) {

        });
    }
}

