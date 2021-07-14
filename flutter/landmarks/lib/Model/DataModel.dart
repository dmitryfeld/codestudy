import 'package:landmarks/Model/AAS/Profile.dart';
import 'package:landmarks/Model/CategoriesAndFeatures.dart';
import 'package:landmarks/Model/Landmark.dart';
import 'package:landmarks/Model/TownsCollection.dart';

class DataModel extends Object {
    List<Landmark> _landmarks;
    CategoriesAndFeatures _categoriesAndFeatures;
    TownsCollection _townsCollection;
    Profile participant;

    DataModel():super() {
        _landmarks = List<Landmark>.empty(growable: true);
        _categoriesAndFeatures = CategoriesAndFeatures();
        _townsCollection = TownsCollection();
    }
    get landmarks {
        return _landmarks;
    }
    get categoriesAndFeatures {
        return _categoriesAndFeatures;
    }
    get townsCollection {
        return _townsCollection;
    }
}