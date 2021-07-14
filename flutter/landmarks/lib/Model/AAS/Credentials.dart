import 'package:flutter/cupertino.dart';
import 'package:landmarks/Model/AAS/Validator.dart';

@immutable class Credentials extends Object {
    final String email;
    final String password;

    const Credentials({this.email, this.password}) : super();

    bool get valid {
        return Validator.validateEmail(this.email) && Validator.validatePassword(this.password);
    }

    Credentials apply({String email,String password}) {
        return Credentials(
            email: email == null ? this.email : email,
            password: password == null ? this.password : password
        );
    }
    static Credentials newCredentials(Map<String,dynamic> map) {
        return Credentials(
            email: map['email'] as String,
            password: map['password'] as String
        );
    }
    Map<String,dynamic> toMap() {
        Map<String,dynamic> result = Map<String,dynamic>();
        result['email'] = this.email;
        result['password'] = this.password;
        return result;
    }
}