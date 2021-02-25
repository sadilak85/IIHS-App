import 'package:flutter/material.dart';

//import './favorites_screen.dart';
import './categories_screen.dart';
import './profiles_screen.dart';
import '../models/meal.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;

  TabsScreen(this.favoriteMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': CategoriesScreen(),
        'title': 'Home',
      },
      {
        'page': CategoriesScreen(),
        'title': 'Vehicle Ratings',
      },
      {
        'page': CategoriesScreen(),
        'title': 'Safety News',
      },
      {
        'page': CategoriesScreen(),
        'title': 'Statistics',
      },
      {
        'page': ProfilesScreen(),
        'title': 'Your Profile',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _pages[_selectedPageIndex]['title'] != 'Your Profile'
      //     ? AppBar(
      //         title: Text(_pages[_selectedPageIndex]['title']),
      //       )
      //     : null,
      // drawer: MainDrawer(),
      body: Stack(
        children: <Widget>[
          _pages[_selectedPageIndex]['page'],
          Positioned(
            left: 0,
            right: 20,
            bottom: 0,
            child: bottomNavigationBar,
          ),
        ],
      ),
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(160),
        //topLeft: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Theme.of(context).bottomAppBarColor,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.calculate),
            label: 'Ratings',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.people_outline),
            label: 'Safety News',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.location_searching),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_circle),
            label: 'My Profile',
          ),
        ],
      ),
    );
  }
}
