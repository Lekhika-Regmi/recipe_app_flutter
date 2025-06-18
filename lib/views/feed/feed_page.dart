import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/recipe_data.dart';
import '../../widgets/recipe_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> images = forYouRecipes
      .map((recipe) => recipe['image'] as String)
      .toList();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Card(
      color: Colors.orangeAccent[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        style: ListTileStyle.drawer,
        title: Text(title),
        leading: Icon(icon, color: Colors.brown[700]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Explore our top liked recipes',
                style: TextStyle(
                  fontFamily: 'Averia_Libre',
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Browse by categories',
                style: TextStyle(
                  fontFamily: 'Averia_Libre',
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 240, // Set appropriate height
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 9,
              mainAxisSpacing: 8,
              padding: const EdgeInsets.all(10),
              childAspectRatio: 3,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView's own scroll
              shrinkWrap: true,
              children: [
                _buildCategoryCard('Breakfast', Icons.free_breakfast),
                _buildCategoryCard('Lunch', Icons.set_meal),
                _buildCategoryCard('Snacks', Icons.local_pizza),
                _buildCategoryCard('Dinner', Icons.fastfood),
                _buildCategoryCard('Vegan', Icons.eco),
                _buildCategoryCard('Brunch', Icons.breakfast_dining_rounded),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'For You',
                style: TextStyle(
                  fontFamily: 'Averia_Libre',
                  color: Colors.brown,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          recipeCard(forYouRecipes),
        ],
      ),
    );
  }
}
