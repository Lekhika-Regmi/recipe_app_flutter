import 'package:flutter/material.dart';

import '../views/feed/feed_page.dart';
import '../views/profile/profile_page.dart';
import '../views/saved/saved_page.dart';
import '../views/uploads/uploads_page.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  // Use a list of functions to create pages, so SavedPage can be refreshed
  List<Widget> get _pages => [
    FeedPage(),
    SavedPage(), // This will be recreated each time
    UploadsPage(),
    ProfilePage(),
  ];

  final List<String> _titles = ['Sharecipe', 'Saved', 'Uploads', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.brown[100],
        shadowColor: Colors.brown[50],
        elevation: 10,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                _titles[_currentIndex],
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Averia_Libre',
                ),
              ),
            ),
            if (_currentIndex == 0) // show icon only on Feed page
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_outlined,
                    size: 30.0,
                    color: Colors.brown[500],
                  ),
                ),
              ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 105,
        child: Material(
          elevation: 20.00,
          shadowColor: Colors.black,
          color: Colors.brown[100],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
            child: BottomNavigationBar(
              unselectedItemColor: Colors.brown[400],
              selectedItemColor: Colors.brown[700],
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.brown[100],
              currentIndex: _currentIndex,
              onTap: (index) => setState(() {
                _currentIndex = index;
              }),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 30),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark, size: 30),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.upload, size: 30),
                  label: 'Uploads',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 30),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
