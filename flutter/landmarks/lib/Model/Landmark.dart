import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngFactory extends Object {
    static LatLng newLatLng(Map<String,dynamic> map) {
        double lat = map['latitude'] as double;
        double lon = map['longitude'] as double;
        return LatLng(lat, lon);
    }
}

class Landmark extends Object {
    int id;
    String name;
    String category;
    String city;
    String park;
    String state;
    String description;
    String imageName;
    bool isFeatured;
    bool isFavorite;
    LatLng coordinates;
    Image thumbnail;
    //GMAP: AIzaSyDmE2QiLcyDL-meV-OKTOY6fNgHEOKOoYU

    Landmark():super();
    Landmark.parametrized(int id,
        String name,
        String category,
        String city,
        String park,
        String state,
        String description,
        String imageName,
        bool isFeatured,
        bool isFavorite,
        LatLng coordinates):
        assert(id != null,'invalid Landmark ID'),
        assert(name != null,'invalid Landmark Name'),
        assert(category != null,'invalid Landmark Category'),
        assert(city != null,'invalid Landmark City'),
        assert(park != null,'invalid Landmark Park'),
        assert(state != null,'invalid Landmark State'),
        assert(description != null, 'invalid Landmark Description'),
        assert(imageName != null, 'invalid Landmark Image Name'),
        assert(isFeatured != null, 'invalid Landmark Featured state'),
        assert(isFavorite != null, 'invalid Landmark Favorite state'),
        assert(coordinates != null,'invalid Landmark Coordinates'),
        super() {
            this.id = id;
            this.name = name;
            this.category = category;
            this.city = city;
            this.park = park;
            this.state = state;
            this.description = description;
            this.imageName = imageName;
            this.isFavorite = isFavorite;
            this.isFeatured = isFeatured;
            this. coordinates = coordinates;
        }

    static Landmark newLandmark(Map<String,dynamic> map) {
        Landmark result = Landmark();
        result.id = map['id'] as int;
        result.name = map['name'] as String;
        result.city = map['city'] as String;
        result.park = map['park'] as String;
        result.state = map['state'] as String;
        result.category = map['category'];
        result.description = map['description'] as String;
        String imageName = map['imageName'] as String;
        result.isFavorite = map['isFavorite'] as bool;
        result.isFeatured = map['isFeatured'] as bool;
        Map<String,dynamic> coordinates = map['coordinates'] as Map<String,dynamic>;
        result.coordinates = LatLngFactory.newLatLng(coordinates);
        result.imageName = 'assets/images/'+ imageName +'.jpg';
        result.thumbnail = Image(image: AssetImage(result.imageName));
        return result;
    }
}