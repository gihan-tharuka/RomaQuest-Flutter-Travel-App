import 'package:romaquest/data/place_seed_data.dart';
import 'package:romaquest/models/place.dart';

class PlaceRepository {
  const PlaceRepository();

  static final List<Place> _places =
      placeSeedData.map((place) => Place.fromJson(place)).toList(growable: false);

  List<Place> getAllPlaces() {
    return List<Place>.unmodifiable(_places);
  }

  List<Place> getPlacesByCategory(String category) {
    return _places.where((place) => place.category == category).toList(growable: false);
  }

  Place? getPlaceByName(String name) {
    for (final place in _places) {
      if (place.name == name) {
        return place;
      }
    }
    return null;
  }
}
