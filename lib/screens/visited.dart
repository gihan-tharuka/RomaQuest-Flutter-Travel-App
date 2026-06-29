import 'package:flutter/material.dart';
import 'package:romaquest/models/place.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:romaquest/theme/app_tokens.dart';
import 'package:romaquest/widgets/empty_state_view.dart';
import 'package:romaquest/widgets/saved_place_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Visited extends StatefulWidget {
  const Visited({Key? key}) : super(key: key);
  @override
  _VisitedState createState() => _VisitedState();
}

class _VisitedState extends State<Visited> {
  List<Place> visitedPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadVisitedPlaces();
  }

  void _loadVisitedPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final visitedString = prefs.getString('visitedPlaces');
    setState(() {
      visitedPlaces = Place.listFromJsonString(visitedString);
    });
  }

  void _removeVisitedPlace(String placeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final visitedList =
        Place.listFromJsonString(prefs.getString('visitedPlaces'));
    visitedList.removeWhere((place) => place.name == placeName);
    await prefs.setString(
      'visitedPlaces',
      Place.listToJsonString(visitedList),
    );
    setState(() {
      visitedPlaces = visitedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visited Places'),
        automaticallyImplyLeading: false,
      ),
      body: visitedPlaces.isEmpty
          ? const EmptyStateView(
              icon: Icons.check_circle_outline,
              title: 'No visits yet',
              message:
                  'No visited places yet. Add one from a place details screen.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: visitedPlaces.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final place = visitedPlaces[index];

                return SavedPlaceTile(
                  place: place,
                  removeLabel: 'Remove from visited',
                  onRemove: () {
                    _removeVisitedPlace(place.name);
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
