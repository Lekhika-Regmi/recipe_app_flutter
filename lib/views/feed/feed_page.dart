// lib/pages/feed/feed_page.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/recipe_data.dart';
import '../../models/recipe_model.dart';
import '../../services/api_service.dart';
import '../../widgets/recipe_card_new.dart';
import '../screens/category_recipes_page.dart'; // Import the new page

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  Timer? _timer;

  // Data state
  List<Recipe> _forYouRecipes = [];
  List<Recipe> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _showSearchResults = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadForYouRecipes();
  }

  // **INTEGRATION FUNCTION: Load recipes from API**
  Future<void> _loadForYouRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recipes = await ApiService().getForYouRecipes();

      setState(() {
        _forYouRecipes = recipes;
        _isLoading = false;
      });

      // Start slideshow after data is loaded
      _startSlideshow();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        // Use fallback data
        _forYouRecipes = forYouRecipes; // Legacy fallback
      });
      _startSlideshow();
    }
  }

  // **SEARCH FUNCTIONALITY**
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Try to search via API first
      final results = await ApiService().searchRecipes(query);
      setState(() {
        _searchResults = results;
        _showSearchResults = true;
        _isSearching = false;
      });
    } catch (e) {
      // Fallback to local search if API fails
      final localResults = _searchLocalRecipes(query);
      setState(() {
        _searchResults = localResults;
        _showSearchResults = true;
        _isSearching = false;
      });
    }
  }

  List<Recipe> _searchLocalRecipes(String query) {
    final lowercaseQuery = query.toLowerCase();

    return _forYouRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowercaseQuery) ||
          recipe.category.name.toLowerCase().contains(lowercaseQuery) ||
          recipe.diet.name.toLowerCase().contains(lowercaseQuery) ||
          recipe.difficulty.name.toLowerCase().contains(lowercaseQuery) ||
          recipe.ingredients.any(
            (ingredient) => ingredient.toLowerCase().contains(lowercaseQuery),
          ) ||
          recipe.instructions.any(
            (instruction) => instruction.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showSearchResults = false;
      _searchResults = [];
    });
  }

  void _startSlideshow() {
    if (_forYouRecipes.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _forYouRecipes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Build search bar widget
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.brown[600]),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search recipes...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: _clearSearch,
            ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: () => _performSearch(_searchController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: _isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }

  // Build search results section
  Widget _buildSearchResults() {
    if (!_showSearchResults) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Results (${_searchResults.length})',
                style: const TextStyle(
                  fontFamily: 'Averia_Libre',
                  color: Colors.brown,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearSearch,
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _searchResults.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No recipes found for "${_searchController.text}"',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : recipeCardNew(
                _searchResults,
                onSavedChanged: () {
                  setState(() {}); // Refresh UI when saved state changes
                },
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Updated method to handle category navigation
  Widget _buildCategoryCard(
    String title,
    IconData icon,
    RecipeCategory category,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to category recipes page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryRecipesPage(
              category: category,
              categoryDisplayName: title,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.orangeAccent[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          style: ListTileStyle.drawer,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.brown[700],
            ),
          ),
          leading: Icon(icon, color: Colors.brown[700]),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.brown[500],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideshow() {
    if (_isLoading) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_forYouRecipes.isEmpty) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Center(child: Text('No recipes available')),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _forYouRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _forYouRecipes[index];
          final imageUrl = recipe.image?.isNotEmpty == true
              ? recipe.image!
              : 'https://us.123rf.com/450wm/yupiramos/yupiramos2208/yupiramos220802258/189948846-recipe-with-vegetables.jpg?ver=6';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://us.123rf.com/450wm/yupiramos/yupiramos2208/yupiramos220802258/189948846-recipe-with-vegetables.jpg?ver=6',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // Overlay with recipe title
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        recipe.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForYouSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.orange, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Failed to load recipes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Using offline data',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadForYouRecipes,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_forYouRecipes.isNotEmpty)
            recipeCardNew(
              _forYouRecipes,
              onSavedChanged: () {
                setState(() {}); // Refresh UI when saved state changes
              },
            ),
        ],
      );
    }

    return recipeCardNew(
      _forYouRecipes,
      onSavedChanged: () {
        setState(() {}); // Refresh UI when saved state changes
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadForYouRecipes,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Search Bar
            _buildSearchBar(),

            // Search Results (only shown when searching)
            _buildSearchResults(),

            // Main content (hidden when showing search results)
            if (!_showSearchResults) ...[
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
              _buildSlideshow(),
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
                height: 260,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 8,
                  padding: const EdgeInsets.all(10),
                  childAspectRatio: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _buildCategoryCard(
                      'Breakfast',
                      Icons.free_breakfast,
                      RecipeCategory.BREAKFAST,
                    ),
                    _buildCategoryCard(
                      'Main Course',
                      Icons.set_meal,
                      RecipeCategory.MAIN_COURSE,
                    ),
                    _buildCategoryCard(
                      'Snacks',
                      Icons.local_pizza,
                      RecipeCategory.SNACK,
                    ),
                    _buildCategoryCard(
                      'Appetizers',
                      Icons.fastfood_outlined,
                      RecipeCategory.APPETIZER,
                    ),
                    _buildCategoryCard(
                      'Dessert',
                      Icons.cake,
                      RecipeCategory.DESSERT,
                    ),
                    _buildCategoryCard(
                      'Soup',
                      Icons.soup_kitchen,
                      RecipeCategory.SOUP,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'For You',
                        style: TextStyle(
                          fontFamily: 'Averia_Libre',
                          color: Colors.brown,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    if (_errorMessage != null)
                      Icon(Icons.cloud_off, color: Colors.orange, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _buildForYouSection(),
            ],
          ],
        ),
      ),
    );
  }
}
