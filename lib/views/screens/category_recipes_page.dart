// lib/pages/category/category_recipes_page.dart
import 'package:flutter/material.dart';

import '../../data/recipe_data.dart';
import '../../models/recipe_model.dart';
import '../../services/api_service.dart';
import '../../widgets/recipe_card_new.dart';

class CategoryRecipesPage extends StatefulWidget {
  final RecipeCategory category;
  final String categoryDisplayName;

  const CategoryRecipesPage({
    super.key,
    required this.category,
    required this.categoryDisplayName,
  });

  @override
  State<CategoryRecipesPage> createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
  List<Recipe> _categoryRecipes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategoryRecipes();
  }

  Future<void> _loadCategoryRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to get recipes from API first
      final allRecipes = await ApiService().getForYouRecipes();

      // Filter recipes by category
      final filteredRecipes = allRecipes
          .where((recipe) => recipe.category == widget.category)
          .toList();

      setState(() {
        _categoryRecipes = filteredRecipes;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to local data
      try {
        final fallbackRecipes = forYouRecipes
            .map(
              (recipeMap) => Recipe.fromJson(recipeMap as Map<String, dynamic>),
            )
            .where((recipe) => recipe.category == widget.category)
            .toList();

        setState(() {
          _categoryRecipes = fallbackRecipes;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      } catch (fallbackError) {
        setState(() {
          _categoryRecipes = [];
          _errorMessage = 'Failed to load recipes';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.brown[300]),
            const SizedBox(height: 16),
            Text(
              'No ${widget.categoryDisplayName} Recipes Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try exploring other categories or check back later!',
              style: TextStyle(fontSize: 14, color: Colors.brown[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCategoryRecipes,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: TextStyle(fontSize: 14, color: Colors.brown[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (_categoryRecipes.isNotEmpty)
              Text(
                'Showing offline data',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCategoryRecipes,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
            SizedBox(height: 16),
            Text(
              'Loading recipes...',
              style: TextStyle(color: Colors.brown, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_categoryRecipes.isEmpty && _errorMessage == null) {
      return _buildEmptyState();
    }

    if (_errorMessage != null && _categoryRecipes.isEmpty) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // Header with recipe count and error indicator
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.brown[200]!),
          ),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(widget.category),
                color: Colors.brown[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_categoryRecipes.length} ${widget.categoryDisplayName} Recipe${_categoryRecipes.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                    if (_errorMessage != null)
                      Text(
                        'Using offline data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              if (_errorMessage != null)
                Icon(Icons.cloud_off, color: Colors.orange, size: 20),
            ],
          ),
        ),

        // Recipe cards
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadCategoryRecipes,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: recipeCardNew(
                _categoryRecipes,
                onSavedChanged: () {
                  setState(() {}); // Refresh UI when saved state changes
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.BREAKFAST:
        return Icons.free_breakfast;
      case RecipeCategory.LUNCH:
        return Icons.lunch_dining;
      case RecipeCategory.DINNER:
        return Icons.dinner_dining;
      case RecipeCategory.MAIN_COURSE:
        return Icons.set_meal;
      case RecipeCategory.APPETIZER:
        return Icons.fastfood_outlined;
      case RecipeCategory.DESSERT:
        return Icons.cake;
      case RecipeCategory.SNACK:
        return Icons.local_pizza;
      case RecipeCategory.SALAD:
        return Icons.eco;
      case RecipeCategory.SOUP:
        return Icons.soup_kitchen;
      case RecipeCategory.BEVERAGE:
        return Icons.local_drink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryDisplayName} Recipes',
          style: const TextStyle(
            fontFamily: 'Averia_Libre',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown[50],
        foregroundColor: Colors.brown[700],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadCategoryRecipes,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(color: Colors.brown[50], child: _buildContent()),
    );
  }
}
