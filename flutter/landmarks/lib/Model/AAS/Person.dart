import 'package:landmarks/Model/AAS/Validator.dart';

class Person extends Object {
    final String firstName;
    final String middleName;
    final String lastName;

    const Person({this.firstName,this.lastName,this.middleName}) : super();
    bool get valid {
        bool mnv = true;
        if (this.middleName != null && this.middleName.length != 0) {
            mnv = Validator.validateName(this.middleName);
        }
        return Validator.validateName(this.firstName) &&  Validator.validateName(this.lastName) && mnv;
    }
    Person apply({String firstName = null,String lastName = null,String middleName = null}) {
        if (firstName == null) {
            firstName = this.firstName;
        }
        if (middleName == null) {
            middleName = this.middleName;
        }
        if (lastName == null) {
            lastName = this.lastName;
        }
        return Person(firstName: firstName,lastName: lastName,middleName: middleName);
    }
    static Person newPerson(Map<String,dynamic> map) {
        return Person(
            firstName: map['firstName'] as String,
            middleName: map['middleName'] as String,
            lastName: map['lastName'] as String
        );
    }
    Map<String,dynamic> toMap() {
        Map<String,dynamic> result = Map<String,dynamic>();
        result['firstName'] = this.firstName;
        result['middleName'] = this.middleName;
        result['lastName'] = this.lastName;
        return result;
    }
}