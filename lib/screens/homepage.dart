import 'package:flutter/material.dart';
import 'package:romaquest/screens/profilePage.dart';
import 'package:romaquest/screens/favoritesPage.dart';
import 'package:romaquest/screens/homecontent.dart';
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
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favourites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Visited',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sunny),
                  label: 'Weather',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
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
