import 'package:flutter/material.dart';
import 'package:romaquest/models/place.dart';
import 'package:romaquest/repositories/place_repository.dart';
import 'package:romaquest/screens/Arrays/categories.dart';
import 'package:romaquest/screens/placedetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:romaquest/screens/loginPage.dart';
import 'package:romaquest/theme/app_tokens.dart';
import 'package:romaquest/widgets/place_card.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Homecontent extends StatefulWidget {
  const Homecontent({Key? key}) : super(key: key);

  @override
  _HomecontentState createState() => _HomecontentState();
}

class _HomecontentState extends State<Homecontent> {
  final PlaceRepository _placeRepository = const PlaceRepository();
  String selectedCategory = categories[0];
  final user = FirebaseAuth.instance.currentUser;
  List<Place> favoritePlaces = [];
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
    _loadProfileImage();
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favoritePlaces');
    setState(() {
      favoritePlaces = Place.listFromJsonString(favoritesString);
    });
  }

  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  void _toggleFavoritePlace(Place place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favoritePlaces');
    final favoriteList = Place.listFromJsonString(favoritesString);

    final isFavorite =
        favoriteList.any((favoritePlace) => favoritePlace.id == place.id);

    if (isFavorite) {
      favoriteList.removeWhere((favoritePlace) => favoritePlace.id == place.id);
    } else {
      favoriteList.add(place);
    }

    await prefs.setString(
      'favoritePlaces',
      Place.listToJsonString(favoriteList),
    );
    _loadFavoritePlaces();
  }

  bool _isFavoritePlace(String placeName) {
    return favoritePlaces.any((favoritePlace) => favoritePlace.name == placeName);
  }

  void signUserOut() async {
    FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryPlaces = _placeRepository.getPlacesByCategory(selectedCategory);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppBorders.sheet,
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello there,',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            user?.email ?? 'Traveller',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Find your next stop in Rome and keep your favourites close.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to log out?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    signUserOut();
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: _profileImagePath != null
                            ? FileImage(File(_profileImagePath!))
                            : const AssetImage('assets/images/profilepic.jpg')
                                as ImageProvider,
                        radius: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Discover Rome',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Browse places by category and open a destination for more details.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return ChoiceChip(
                      selected: isSelected,
                      label: Text(category),
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      avatar: Icon(
                        _categoryIcon(category),
                        size: 18,
                        color: isSelected
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                      ),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      selectedColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorders.pill,
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.secondary
                              : theme.dividerColor,
                        ),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${categoryPlaces.length} places',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final place in categoryPlaces) ...[
                PlaceCard(
                  place: place,
                  isFavorite: _isFavoritePlace(place.name),
                  onFavoriteToggle: () {
                    _toggleFavoritePlace(place);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PlaceDetailsScreen(
                          place: place,
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
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Attractions':
        return Icons.location_city_rounded;
      case 'Hotels':
        return Icons.hotel_rounded;
      case 'Restaurants':
        return Icons.restaurant_rounded;
      case 'Others':
        return Icons.explore_rounded;
      default:
        return Icons.place_rounded;
    }
  }
}
