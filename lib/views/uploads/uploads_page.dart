import 'package:flutter/material.dart';

import '../../models/recipe_model.dart';
import '../../services/api_service.dart';
import '../../widgets/recipe_card_new.dart';
import 'add_recipe_page.dart';

class UploadsPage extends StatefulWidget {
  const UploadsPage({super.key});

  @override
  State<UploadsPage> createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  List<Recipe> _uploadedRecipes = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUploadedRecipes();
  }

  Future<void> fetchUploadedRecipes() async {
    try {
      setState(() => _isLoading = true);

      // Get only current user's recipes
      final recipes = await _apiService.getUserRecipes();

      setState(() {
        _uploadedRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading uploaded recipes: $e');
      setState(() => _isLoading = false);

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load recipes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteRecipe(String recipeId) async {
    // Show confirmation dialog
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text(
            'Are you sure you want to delete this recipe? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deleting recipe...'),
            duration: Duration(seconds: 1),
          ),
        );

        await _apiService.deleteRecipe(recipeId);

        // Remove from local list immediately for better UX
        setState(() {
          _uploadedRecipes.removeWhere((recipe) => recipe.recipeId == recipeId);
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('Error deleting recipe: $e');

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete recipe: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        // Refresh the list to ensure consistency
        fetchUploadedRecipes();
      }
    }
  }

  Future<void> _refreshRecipes() async {
    await fetchUploadedRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add recipe page and refresh when returning
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipePage()),
          );

          // If a recipe was added, refresh the list
          if (result == true) {
            _refreshRecipes();
          }
        },
        tooltip: 'Add Recipe',
        backgroundColor: Colors.brown[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: _refreshRecipes,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _uploadedRecipes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.brown[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recipes uploaded yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to share your first recipe',
                      style: TextStyle(fontSize: 14, color: Colors.brown[400]),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // User info header
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.brown[600],
                          radius: 20,
                          child: Text(
                            'U${_apiService.getCurrentUserId()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Recipes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                              ),
                            ),
                            Text(
                              '${_uploadedRecipes.length} recipe${_uploadedRecipes.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.brown[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Recipes grid
                  Expanded(
                    child: recipeCardNew(
                      _uploadedRecipes,
                      showDelete: true,
                      onRecipeDeleted: _deleteRecipe,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
