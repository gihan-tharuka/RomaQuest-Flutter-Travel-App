import 'package:flutter/material.dart';
import 'package:romaquest/models/place.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:romaquest/theme/app_tokens.dart';
import 'package:romaquest/widgets/empty_state_view.dart';
import 'package:romaquest/widgets/saved_place_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Place> favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favoritePlaces');
    setState(() {
      favoritePlaces = Place.listFromJsonString(favoritesString);
    });
  }

  void _removeFavoritePlace(String placeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoriteList =
        Place.listFromJsonString(prefs.getString('favoritePlaces'));
    favoriteList.removeWhere((place) => place.name == placeName);
    await prefs.setString(
      'favoritePlaces',
      Place.listToJsonString(favoriteList),
    );
    setState(() {
      favoritePlaces = favoriteList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Places'),
        automaticallyImplyLeading: false,
      ),
      body: favoritePlaces.isEmpty
          ? const EmptyStateView(
              icon: Icons.favorite_outline,
              title: 'Nothing saved yet',
              message:
                  'No favourite places yet. Tap the heart on a place to save it here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: favoritePlaces.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final place = favoritePlaces[index];

                return SavedPlaceTile(
                  place: place,
                  removeLabel: 'Remove from favourites',
                  onRemove: () {
                    _removeFavoritePlace(place.name);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(
                          place: place,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
