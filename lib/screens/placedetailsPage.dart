
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:romaquest/models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final Place place;

  const PlaceDetailsScreen({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool _isFavorite = false;
  bool _isVisited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _checkIfVisited();
  }

  void _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoriteList =
        Place.listFromJsonString(prefs.getString('favoritePlaces'));
    setState(() {
      _isFavorite = favoriteList.any((place) => place.id == widget.place.id);
    });
  }

  void _checkIfVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final visitedList =
        Place.listFromJsonString(prefs.getString('visitedPlaces'));
    setState(() {
      _isVisited = visitedList.any((place) => place.id == widget.place.id);
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoriteList =
        Place.listFromJsonString(prefs.getString('favoritePlaces'));

    if (_isFavorite) {
      favoriteList.removeWhere((place) => place.id == widget.place.id);
    } else {
      favoriteList.add(widget.place);
    }

    await prefs.setString(
      'favoritePlaces',
      Place.listToJsonString(favoriteList),
    );

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _toggleVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final visitedList =
        Place.listFromJsonString(prefs.getString('visitedPlaces'));

    if (_isVisited) {
      visitedList.removeWhere((place) => place.id == widget.place.id);
    } else {
      visitedList.add(widget.place);
    }

    await prefs.setString(
      'visitedPlaces',
      Place.listToJsonString(visitedList),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isVisited = !_isVisited;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isVisited ? 'Added to visited places.' : 'Removed from visited places.',
        ),
      ),
    );
  }

  Future<void> _showLocationDetails() async {
    final searchQuery = '${widget.place.name}, Rome, Italy';
    final mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(searchQuery)}';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search for this place in maps:'),
              SizedBox(height: 8),
              SelectableText(searchQuery),
              SizedBox(height: 12),
              SelectableText(mapsUrl),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: mapsUrl));
                if (!context.mounted) {
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text('Maps link copied to clipboard.')),
                );
              },
              child: Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.place.image,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 35,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(1),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(1),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: _isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        _toggleFavorite();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.place.name,
                        style: TextStyle(
                          fontSize: 24,
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
                            '${widget.place.rating}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(widget.place.description),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Open Days:  ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.place.days,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Open Hours:  ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.place.hours,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showLocationDetails,
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Get location',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _toggleVisited,
                        icon: Icon(
                          _isVisited ? Icons.check_circle : Icons.check,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isVisited ? 'Visited' : 'Add to Visited',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
