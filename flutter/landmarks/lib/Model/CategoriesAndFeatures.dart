
import 'package:landmarks/Model/Landmark.dart';

class CategoriesAndFeatures extends Object {
    Map<String,List<Landmark>> categories;
    List<Landmark> features;

    CategoriesAndFeatures():super(){
        this.categories = Map<String,List<Landmark>>();
        this.features = List<Landmark>.empty(growable: true);
    }

    void addToCategories(Landmark landmark) {
      List<Landmark> landmarks = this.categories[landmark.category];
      if (null == landmarks) {
        landmarks = List<Landmark>.empty(growable: true);
        this.categories[landmark.category] = landmarks;
      }
      if (!landmarks.contains(landmark)) {
        landmarks.add(landmark);
      }
    }
    void addToFeatures(Landmark landmark) {
      if (landmark.isFeatured) {
        this.features.add(landmark);
      }
    }
}