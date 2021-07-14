import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:landmarks/Model/TownsCollection.dart';

class Validator extends Object {
    static bool validateZip(String zip) {
        return Validator.match(r'^\d{5}([\-]?\d{4})?$', zip);
    }
    static bool validatePhone(String phone) {
        return Validator.match(r'(^(?:[+0]9)?[0-9]{10,12}$)', phone);
    }
    static bool validateEmail(String email) {
        return Validator.match(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$', email);
    }
    static bool validateUserName(String userName) {
        return Validator.match(r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$', userName);
    }
    static bool validatePassword(String password) {
        return Validator.match(r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$',password);
    }
    static bool validateStreerAddress(String streetAddress) {
        return Validator.match(r'\d{1,6}\s(?:[A-Za-z0-9#]+\s){0,7}(?:[A-Za-z0-9#]+,)\s*(?:[A-Za-z]+\s){0,3}(?:[A-Za-z]+,)\s*[A-Z]{2}\s*\d{5}', streetAddress);
    }
    static bool validateName(String name) {
        return Validator.match(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$", name);
    }
    static bool validateState(String state) {
        DataModel model = Environment.model;
        TownsCollection towns = model.townsCollection;
        return towns.validateState(state);
    }
    static bool validateCity(String city) {
        DataModel model = Environment.model;
        TownsCollection towns = model.townsCollection;
        return towns.validateTown(city);
    }
    
    static bool match(String pattern, String value) {
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value))  return false;
      return true;
    }
}