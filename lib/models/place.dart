import 'dart:convert';

class Place {
  const Place({
    required this.name,
    required this.image,
    required this.description,
    required this.rating,
    required this.hours,
    required this.days,
    required this.category,
  });

  final String name;
  final String image;
  final String description;
  final int rating;
  final String hours;
  final String days;
  final String category;

  String get id => name;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      rating: json['rating'] as int,
      hours: json['hours'] as String,
      days: json['days'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'rating': rating,
      'hours': hours,
      'days': days,
      'category': category,
    };
  }

  static List<Place> listFromJsonString(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<Place> places) {
    return json.encode(places.map((place) => place.toJson()).toList());
  }
}
