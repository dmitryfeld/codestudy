import 'package:email_validator/email_validator.dart';
import 'package:landmarks/Model/AAS/Validator.dart';

class Contact extends Object {
    final String email;
    final String phone;
    const Contact({this.email,this.phone}) : super();

    bool get valid {
        return Validator.validateEmail(email) && Validator.validatePhone(phone);
    }
    Contact apply({String email = null,String phone = null}) {
        if (email == null) {
            email = this.email;
        }
        if (phone == null) {
            phone = this.phone;
        }
        return Contact(email: email,phone: phone);
    }
    static Contact newContact(Map<String,dynamic> map) {
        return Contact(
            phone: map['phone'] as String,
            email: map['email'] as String
        );
    }
    Map<String,dynamic> toMap() {
        Map<String,dynamic> result = Map<String,dynamic>();
        result['phone'] = this.phone;
        result['email'] = this.email;
        return result;
    }
}