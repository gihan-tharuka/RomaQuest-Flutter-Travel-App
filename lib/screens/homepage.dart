import 'package:flutter/material.dart';
import 'package:romaquest/screens/profilePage.dart';
import 'package:romaquest/screens/favoritesPage.dart';
import 'package:romaquest/screens/homecontent.dart';
import 'package:romaquest/theme/app_tokens.dart';
import 'package:romaquest/screens/visited.dart';
import 'package:romaquest/screens/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  static const List<Widget> _pages = [
    FavouritesPage(),
    Visited(),
    Homecontent(),
    Weather(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor:
                  Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 22,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.favorite_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.favorite),
                  ),
                  label: 'Favourites',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.check_circle_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.check_circle),
                  ),
                  label: 'Visited',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.home_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.wb_sunny_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.sunny),
                  ),
                  label: 'Weather',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.person_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.person),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
