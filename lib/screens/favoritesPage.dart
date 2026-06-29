import 'package:flutter/material.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Map<String, dynamic>> favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favoritePlaces');
    List<Map<String, dynamic>> loadedPlaces = [];
    if (favoritesString != null) {
      List<dynamic> favoriteList = json.decode(favoritesString);
      loadedPlaces = favoriteList.cast<Map<String, dynamic>>();
    }
    setState(() {
      favoritePlaces = loadedPlaces;
    });
  }

  void _removeFavoritePlace(String placeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favoritePlaces');
    if (favoritesString != null) {
      List<dynamic> favoriteList = json.decode(favoritesString);
      favoriteList.removeWhere((place) => place['name'] == placeName);
      await prefs.setString('favoritePlaces', json.encode(favoriteList));
      setState(() {
        favoritePlaces = favoriteList.cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Places'),
        automaticallyImplyLeading: false,
      ),
      body: favoritePlaces.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No favourite places yet. Tap the heart on a place to save it here.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (var place in favoritePlaces)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailsScreen(
                              name: place['name']!,
                              image: place['image']!,
                              description: place['description']!,
                              rating: place['rating']!,
                              hours: place['hours']!,
                              days: place['days']!,
                              category: place['category']!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.asset(
                                    place['image']!,
                                    width: double.infinity,
                                    height: 170,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _removeFavoritePlace(place['name']!);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          color: Colors.pink,
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          place['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rating: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${place['rating']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
