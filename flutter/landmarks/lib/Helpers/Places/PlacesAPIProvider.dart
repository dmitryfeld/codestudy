import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:landmarks/Model/AAS/Address.dart';
import 'package:uuid/uuid.dart';

class Suggestion {
    final String placeId;
    final String description;

    Suggestion(this.placeId, this.description);

    @override String toString() {
        return 'Suggestion(description: $description, placeId: $placeId)';
    }
}

@immutable class PlacesAPIProvider extends Object {
    static final String apiKey = 'AIzaSyDmE2QiLcyDL-meV-OKTOY6fNgHEOKOoYU';

    final client = Client();
    final String language;
    final String country;
    final String sessionToken;

    PlacesAPIProvider({@required this.sessionToken,@required this.language,@required this.country}) :
        assert(sessionToken != null,'SessionToken can not be null'),
        assert(sessionToken.length != null,'SessionToken can not be empty'),
        assert(language != null,'Language can not be null'),
        assert(language.length > 0,'Language can not be ampty'),
        assert(country != null,'Country can not be null'),
        assert(country.length > 0,'Country can not be ampty'),
        super();

    Future<List<Suggestion>> fetchSuggestions(String input) async {
        //https://cors-anywhere.herokuapp.com/
        final String prefix = 'https://cors-anywhere.herokuapp.com/';
        final String request = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$language&components=country:$country&key=$apiKey&sessiontoken=$sessionToken';
        final response = await client.get(kIsWeb == true? prefix + request : request);
        if (response.statusCode == 200) {
            final result = json.decode(response.body);
            if (result['status'] == 'OK') {
                List<dynamic> predictions = result['predictions'] as List<dynamic>;
                return predictions.map<Suggestion>(
                    (predictionP) {
                        return Suggestion(predictionP['place_id'], predictionP['description']);
                    }
                ).toList();
            }
        }
        return null;
    }

    Future<Address> getPlaceDetailFromId(String placeId) async {
        final String prefix = 'https://cors-anywhere.herokuapp.com/';
        final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
        final response = await client.get(kIsWeb == true? prefix + request : request);
        if (response.statusCode == 200) {
            final result = json.decode(response.body);
            return Address.newGoogleAddress(result);
        }
        return null;
    }

    Future<Address> directGeo(Location location) async {
        final googleString = location.toGoogleString();
        final request = 'https://maps.googleapis.com/maps/api/geocode/json?$googleString&key=$apiKey';
        final response = await client.get(request);
        if (response.statusCode == 200) {
            final result = json.decode(response.body);
            return Address.newGoogleAddress(result);
        }
        return null;
    }

    Future<Location> reverseGeo(Address address) async {
        final googleString = address.toGoogleString();
        final request = "https://maps.googleapis.com/maps/api/geocode/json?components=$googleString&key=$apiKey";
        final response = await client.get(request);
        if (response.statusCode == 200) {
            final result = json.decode(response.body);
            return Location.newGoogleLocation(result);
        }
        return null;
    }
}
