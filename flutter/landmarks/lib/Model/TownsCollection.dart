
import 'package:flutter/cupertino.dart';

@immutable class CityState {
    final String city;
    final String state;
    const CityState({this.city,this.state});
    @override String toString() {
        return 'city: $city, state: $state';
    }
    CityState apply({String city,String state}) {
        return CityState(
            city: city == null ? this.city : city,
            state: state == null ? this.state : state
        );
    }
}
class Towns extends Object {
    String stateName;
    String stateCode;
    String fipsCode;
    List<String> cities;

    Towns():super(){}
    Towns.parametrized(int id,
        String stateName,
        String stateCode,
        String fipsCode,
        List<String> cities):
          assert(stateName != null,'invalid State Name'),
          assert(stateCode != null,'invalid State Code'),
          assert(fipsCode != null,'invalid FIPS Code'),
          assert(cities != null,'invalid Cities'),
          super() {
      this.stateName = stateName;
      this.stateCode = stateCode;
      this.fipsCode = fipsCode;
      this.cities = List.from(cities);
    }

    static Towns newTowns(Map<String,dynamic> map) {
      Towns result = Towns();
      result.stateName = map['stateName'] as String;
      result.stateCode = map['stateCode'] as String;
      result.fipsCode = map['fipsCode'] as String;
      result.cities = Towns.convert(map['cities'] as List<dynamic>);
      return result;
    }

    static List<String> convert(List<dynamic> list) {
        List<String> result = List<String>.empty(growable: true);
        for (dynamic temp  in list) {
            if (temp is String) {
                result.add(temp as String);
            }
        }
        return result;
    }
}

class TownsCollection extends Object {
    final Map<String,Towns> _content = Map<String,Towns>();
    get content {
        return this._content;
    }
    void addTowns(Towns stateTowns) {
        this._content[stateTowns.stateCode] = stateTowns;
    }
    bool validateState(String state) {
        if (this._content[state] != null) {
            return true;
        }
        for (Towns stateTowns in _content.values) {
            if (stateTowns.stateName == state) {
                return true;
            }
        }
        return false;
    }
    bool validateTown(String town) {
       return this.findTownState(town) != null;
    }
    String findTownState(String town) {
        for (Towns stateTowns in _content.values) {
            for (String city in stateTowns.cities) {
                if (city == town ) {
                    return stateTowns.stateName;
                }
            }
        }
        return null;
    }
    void clear() {
        _content.clear();
    }
}