
import 'package:flutter/material.dart';
import 'package:landmarks/MainController.dart';
import 'package:landmarks/Model/AAS/Credentials.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/Environment.dart';

typedef OnLoginSubmitButtonPressed(Credentials credentialsP);

@immutable class Login extends StatefulWidget {
    final OnLoginSubmitButtonPressed onLoginSubmitButtonPressed;
    final Credentials credentials;
    final bool shallHidePassword;

    const Login({
        @required this.credentials,
        @required this.onLoginSubmitButtonPressed,
        this.shallHidePassword = true,
        Key key
    }): assert(credentials != null,'Credentials can not be null'),
        assert(onLoginSubmitButtonPressed != null,'OnLoginSubmitButtonPressed can not be null'),
        super(key: key);

    @override LoginState createState() {
        return LoginState();
    }
}

class LoginState extends State<Login> {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _shallHidePassword;

    @override void initState() {
        super.initState();
        if (widget.credentials != null) {
            this._emailController.text = widget.credentials.email;
            this._passwordController.text = widget.credentials.password;
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
                            return null;
                        }
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Container(
                            constraints: BoxConstraints.expand(height: 45),
                            color: Colors.yellow,
                            child: this._createSubmitButton(context)
                        )
                    ),
                    Container(
                        constraints: BoxConstraints.expand(height: 45),
                        //color: Colors.yellow,
                        child: Row (
                          children: [
                            this._createServiceButton(context,'Sign On'),
                            Spacer(),
                            this._createServiceButton(context,'Forgot Password?')
                          ],
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
                    widget.onLoginSubmitButtonPressed(
                        Credentials (
                            email:this._emailController.text,
                            password:this._passwordController.text
                        )
                    );
                }
            },
            child: Text('Submit')
        );
    }
    Widget _createServiceButton(BuildContext context,String title) {
        Container child = Container (
            constraints: BoxConstraints.expand(width: 130),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).buttonTheme.colorScheme.primary//Colors.lightBlue.shade900
                    )
                )
            ),
            child: Text(title)
        );
        return MaterialButton(
            onPressed: (){}, child: child,
            padding: EdgeInsets.all(0),
        );
    }
}

class LoginController extends StatefulWidget {
    final Credentials credentials;
    const LoginController({this.credentials,Key key}) :
        super(key: key);

    @override LoginControllerState createState() {
        return LoginControllerState();
    }
}

class LoginControllerState extends State<LoginController> {
    @override void initState() {
        super.initState();
    }
    @override Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: Align(
              alignment:Alignment.topCenter ,
              child: Login(
                  credentials: widget.credentials,
                  onLoginSubmitButtonPressed: onLoginSubmitButtonPressed,
              ),
            )
        );
    }
    void onLoginSubmitButtonPressed(Credentials credentialsP) {




        MaterialPageRoute route = MaterialPageRoute(
            builder: (context){
              return MainController(
                  dataModel: Environment.model
              );
            }
        );
        showAlertDialog(this.context);
        Future.delayed(const Duration(seconds: 2), (){}).then((value) {
            Navigator.pop(this.context);
            Navigator.pushReplacement(this.context, route).then((value) {

            });
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
        showDialog(barrierDismissible: false,
            context:context,
            builder:(BuildContext context){
                return alert;
            }
        );
    }
}
