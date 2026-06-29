import 'package:flutter/material.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Visited extends StatefulWidget {
  const Visited({Key? key}) : super(key: key);
  @override
  _VisitedState createState() => _VisitedState();
}

class _VisitedState extends State<Visited> {
  List<Map<String, dynamic>> visitedPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadVisitedPlaces();
  }

  void _loadVisitedPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? visitedString = prefs.getString('visitedPlaces');
    List<Map<String, dynamic>> loadedPlaces = [];
    if (visitedString != null) {
      List<dynamic> visitedList = json.decode(visitedString);
      loadedPlaces = visitedList.cast<Map<String, dynamic>>();
    }
    setState(() {
      visitedPlaces = loadedPlaces;
    });
  }

  void _removeVisitedPlace(String placeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? visitedString = prefs.getString('visitedPlaces');
    if (visitedString != null) {
      List<dynamic> visitedList = json.decode(visitedString);
      visitedList.removeWhere((place) => place['name'] == placeName);
      await prefs.setString('visitedPlaces', json.encode(visitedList));
      setState(() {
        visitedPlaces = visitedList.cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visited Places'),
        automaticallyImplyLeading: false,
      ),
      body: visitedPlaces.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No visited places yet. Add one from a place details screen.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (var place in visitedPlaces)
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
                                        _removeVisitedPlace(place['name']!);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          color: Colors.black54,
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
