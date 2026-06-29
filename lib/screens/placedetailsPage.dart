
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:romaquest/models/place.dart';
import 'package:romaquest/theme/app_tokens.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: Image.asset(
                    widget.place.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.12),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.38),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 44,
                  left: 20,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: const Icon(
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
                  top: 44,
                  right: 20,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? theme.colorScheme.secondary : Colors.white,
                      ),
                      onPressed: () {
                        _toggleFavorite();
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: AppBorders.pill,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 6,
                          ),
                          child: Text(
                            widget.place.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.place.name,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            _DetailMetaChip(
                              icon: Icons.star_rounded,
                              label: '${widget.place.rating}.0 rating',
                              iconColor: const Color(0xFFE0A020),
                            ),
                            _DetailMetaChip(
                              icon: Icons.calendar_today_rounded,
                              label: widget.place.days,
                            ),
                            _DetailMetaChip(
                              icon: Icons.schedule_rounded,
                              label: widget.place.hours,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _DetailSection(
                          title: 'About this place',
                          child: Text(
                            widget.place.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _showLocationDetails,
                                icon: const Icon(Icons.location_on_outlined),
                                label: const Text('Get location'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _toggleVisited,
                                icon: Icon(
                                  _isVisited ? Icons.check_circle : Icons.check,
                                ),
                                label: Text(
                                  _isVisited ? 'Visited' : 'Add to Visited',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan your stop',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Use the location action for a quick maps search, or mark this place once you have been there.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
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

class _DetailMetaChip extends StatelessWidget {
  const _DetailMetaChip({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: AppBorders.pill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: iconColor ?? theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
