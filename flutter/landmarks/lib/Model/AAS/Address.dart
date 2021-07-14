import 'package:flutter/material.dart';
import 'package:landmarks/Model/AAS/Validator.dart';
import 'package:landmarks/Model/DataModel.dart';
import 'package:landmarks/Model/Environment.dart';
import 'package:landmarks/Model/TownsCollection.dart';

class Address extends Object {
    final String number;
    final String street;
    final String unit;
    final String city;
    final String state;
    final String country;
    final String zipCode;

    const Address({this.number,this.street,this.unit,this.city,this.state,this.country,this.zipCode}) : super();
    bool get valid {
        return Validator.validateZip(this.zipCode) &&
            Validator.validateStreerAddress(this.street) &&
            Validator.validateCity(this.city) &&
            Validator.validateState(this.state);
    }
    Address apply({String number,String street,String unit,String city,String state,String country,String code}) {
        return Address(
            number: number == null ? this.number : number,
            street: street == null ? this.street : street,
            unit: unit == null ? this.unit : unit,
            city: city == null ? this.city : city,
            state: state == null ? this.state : state,
            country: country == null ? this.country : country,
            zipCode: code == null ? this.zipCode : code
        );
    }
    static Address newAddress(Map<String,dynamic> map) {
        return Address(
            number: map['number'] as String,
            street: map['street'] as String,
            unit: map['unit'] as String,
            city: map['city'] as String,
            state: map['state'] as String,
            zipCode: map['zipCode'] as String,
            country: map['country'] as String
        );
    }
    static Address newGoogleAddress(Map<String,dynamic> map) {
        Address result = null;
        if (map['status'] == 'OK') {
            final components = map['result']['address_components'] as List<dynamic>;
            String number = '';
            String street = '';
            String city = '';
            String zipCode = '';
            String state = '';
            String country = '';
            components.forEach(
                (component) {
                    final List type = component['types'];
                    if (type.contains('street_number')) {
                        number = component['long_name'];
                    }
                    if (type.contains('route')) {
                        street = component['long_name'];
                    }
                    if (type.contains('locality')) {
                        city = component['long_name'];
                    }
                    if (type.contains('postal_code')) {
                        zipCode = component['long_name'];
                    }
                    if (type.contains('administrative_area_level_1')) {
                        state = component['long_name'];
                    }
                    if (type.contains('country')) {
                        country = component['short_name'];
                    }
                }
            );
            result = Address(
                number: number,
                street: street,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country
            );
        }
        return result;
    }

    @override String toString() {
        return 'Address:(number: $number street: $street unit $unit city: $city state: $state zip: $zipCode country: $country)';
    }
    String toGoogleString() {
        String numberS = this.number == null ? '' : this.number.length == 0 ? '' : 'street_number:$number';
        String streetS = this.street == null ? '' : this.street.length == 0 ? '' : 'route:$street';
        String cityS = this.city == null ? '' : this.city.length == 0 ? '' : 'locality:$city';
        String zipS = this.zipCode == null ? '' : this.zipCode.length == 0 ? '' : 'postal_code:$zipCode';
        String stateS = this.state == null ? '' : this.state.length == 0 ? '' : 'administrative_area_level_1:$state';
        String countryS = this.country == null ? '' : this.country.length == 0 ? '' : 'country:$country';

        String result = numberS + (streetS.length > 0 ? '|$streetS' : '');
        result += (cityS.length > 0 ? '|$cityS' : '');
        result += (zipS.length > 0 ? '|$zipS' : '');
        result += (stateS.length > 0 ? '|$stateS' : '');
        result += (countryS.length > 0 ? '|$countryS' : '');

        return result;
    }
    Map<String,dynamic> toMap() {
        Map<String,dynamic> result = Map<String,dynamic>();
        result['number'] = this.number;
        result['street'] = this.street;
        result['unit'] = this.unit;
        result['city'] = this.city;
        result['state'] = this.state;
        result['zipCode'] = this.zipCode;
        result['country'] = this.country;
        return result;
    }
}

class Location extends Object {
    final double latitude;
    final double longitude;
    final List<String> types;

    Location({@required this.latitude,@required this.longitude,@required this.types}):
        assert(latitude != null,'Latitude can not be null'),
        assert(longitude != null,'Longitude can not be null'),
        assert(types != null,'Type can not be null'),
        assert(types.length != 0,'Type can not be empty'),
        super();

    static Location newLocation(Map<String,dynamic> map) {
        return Location(
            latitude: map['latitude'] as double,
            longitude: map['longitude'] as double,
            types: map['types'] as List<String>
        );
    }
    static Location newGoogleLocation(Map<String,dynamic> map) {
        Location result = null;
        if (map['status'] == 'OK') {
            List<dynamic> results = map['results'] as List<dynamic>;
            if (results.length > 0) {
                Map<String,dynamic> temp = results[0] as Map<String,dynamic>;
                Map<String,dynamic>geometry = temp['geometry'] as Map<String,dynamic>;
                List<dynamic> types = temp['types'] as List<dynamic>;
                if (geometry != null) {
                    Map<String,dynamic> location = geometry['location'] as Map<String,dynamic>;
                    if (location != null) {
                        double lat = location['lat'] as double;
                        double lng = location['lng'] as double;
                        result = Location(latitude: lat,longitude: lng,types: Location.stringify(types));
                    }
                }
            }
        }
        return result;
    }
    @override String toString() {
        return 'Location:(latitude: $latitude longitude: $longitude types $types)';
    }
    String toGoogleString() {
        return 'latlng:$latitude,$longitude&result_type=street_address&';
    }
    @protected static List<String> stringify(List<dynamic> list) {
        List<String> result = List<String>.empty(growable: true);
        for (dynamic element in list) {
            result.add(element.toString());
        }
        return result;
    }
}