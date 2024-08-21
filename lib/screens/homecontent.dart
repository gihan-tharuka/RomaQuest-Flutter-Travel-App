
import 'package:flutter/material.dart';
import 'package:sample_project/screens/Arrays/categories.dart';
import 'package:sample_project/screens/placedetailsPage.dart';
import 'package:sample_project/screens/Arrays/places.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_project/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class Homecontent extends StatefulWidget {
  const Homecontent({Key? key}) : super(key: key);

  @override
  _HomecontentState createState() => _HomecontentState();
}

class _HomecontentState extends State<Homecontent> {
  String selectedCategory = categories[0];
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> favoritePlaces = [];
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
    _loadProfileImage();
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favoritePlaces');
    if (favoritesString != null) {
      List<dynamic> favoriteList = json.decode(favoritesString);
      favoritePlaces = favoriteList.cast<Map<String, dynamic>>();
    }
    setState(() {});
  }

  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  void _toggleFavoritePlace(Map<String, dynamic> place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favoritePlaces');
    List<dynamic> favoriteList =
        favoritesString != null ? json.decode(favoritesString) : [];

    bool isFavorite = favoriteList
        .any((favoritePlace) => favoritePlace['name'] == place['name']);

    if (isFavorite) {
      favoriteList.removeWhere(
          (favoritePlace) => favoritePlace['name'] == place['name']);
    } else {
      favoriteList.add(place);
    }

    await prefs.setString('favoritePlaces', json.encode(favoriteList));
    _loadFavoritePlaces();
  }

  bool _isFavoritePlace(String placeName) {
    return favoritePlaces
        .any((favoritePlace) => favoritePlace['name'] == placeName);
  }

  void signUserOut() async {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categoryPlaces =
        places.where((place) => place['category'] == selectedCategory).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 20.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello,\n',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: user?.email,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to log out?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  signUserOut();
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: _profileImagePath != null
                          ? FileImage(File(_profileImagePath!))
                          : AssetImage('assets/images/profilepic.jpg')
                              as ImageProvider,
                      radius: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index];
                          });
                        },
                        child: Chip(
                          label: Text(
                            categories[index],
                            style: TextStyle(
                              color: selectedCategory == categories[index]
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          backgroundColor: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.black,
                          elevation: 2.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            for (var place in categoryPlaces)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PlaceDetailsScreen(
                        name: place['name']!,
                        image: place['image']!,
                        description: place['description']!,
                        rating: place['rating']!,
                        hours: place['hours']!,
                        days: place['days']!,
                        category: place['category']!,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: Theme.of(context).cardTheme.color,
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
                            IconButton(
                              icon: Icon(
                                _isFavoritePlace(place['name']!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _toggleFavoritePlace(place);
                              },
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
