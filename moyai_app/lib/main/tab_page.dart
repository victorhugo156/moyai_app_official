import 'package:flutter/material.dart';
import 'package:moyai_app/explore/view/favourites_page.dart';
import 'package:moyai_app/main/google_map_page.dart';
import 'package:moyai_app/profile/view/profile_page.dart';
import 'package:moyai_app/explore/view/explore_page.dart';
import 'package:moyai_app/utils/themes/color_pallet.dart';


class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  //New
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = [
    GoogleMapPage(),
    SearchPage(),
    FavouritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        unselectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        selectedIconTheme: const IconThemeData(color: ColorPalette.primary),
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            label: "Maps",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
