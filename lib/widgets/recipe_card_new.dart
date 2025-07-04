// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:recipe_app/views/screens/recipe_detail_page.dart';

import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
//import '../services/api_service.dart';

// Helper function to format time ago
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '${minutes}m ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '${hours}h ago';
  } else if (difference.inDays < 30) {
    final days = difference.inDays;
    return '${days}d ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '${months} months ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '${years} years ago';
  }
}

// New widget for Recipe objects
Widget recipeCardNew(
  List<Recipe> recipes, {
  bool showDelete = false,
  Function(String)? onRecipeDeleted,
  VoidCallback? onSavedChanged,
}) {
  Widget getDifficultyChip(Difficulty difficulty) {
    Color chipColor;
    switch (difficulty) {
      case Difficulty.EASY:
        chipColor = Colors.green;
        break;
      case Difficulty.MEDIUM:
        chipColor = Colors.orange;
        break;
      case Difficulty.HARD:
        chipColor = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        difficulty.displayName,
        style: TextStyle(
          fontSize: 10,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      child: StatefulBuilder(
        builder: (context, setState) {
          return GridView.builder(
            itemCount: recipes.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final isSaved = isRecipeSaved(recipe.recipeId);

              return TextButton(
                onPressed: () {
                  // In your onPressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(recipe: recipe),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Section
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                recipe.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/default.jpg',
                                    fit: BoxFit.cover,
                                  );
                                  // return Image.network(
                                  //   'https://cdn.vectorstock.com/i/500p/19/46/culinary-recipe-book-page-or-menu-card-for-notes-vector-41611946.jpg',
                                  //   fit: BoxFit.cover,
                                  // );
                                },
                              ),
                              // Category badge
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    recipe.category.displayName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Info Section
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Created: ${formatTimeAgo(recipe.createdAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getDifficultyChip(recipe.difficulty),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recipe.diet.displayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      if (showDelete) {
                                        // Handle delete
                                        onRecipeDeleted?.call(recipe.recipeId);
                                      } else {
                                        // Handle save/unsave with immediate UI update
                                        toggleSavedRecipe(recipe.recipeId);
                                        setState(
                                          () {},
                                        ); // This triggers immediate UI update
                                        onSavedChanged?.call();
                                      }
                                    },
                                    icon: showDelete
                                        ? Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          )
                                        : Icon(
                                            isSaved
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: isSaved
                                                ? Colors.brown[700]
                                                : Colors.brown,
                                            size: 20,
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

// Legacy widget for backward compatibility with old format
Widget recipeCard(
  List<Map<String, dynamic>> recipes, {
  bool showDelete = false,
  Function(String)? onRecipeDeleted,
  VoidCallback? onSavedChanged,
}) {
  // Helper function to parse date string and format time ago for legacy format
  String formatTimeAgoFromString(String? dateString) {
    if (dateString == null || dateString.isEmpty || dateString == 'Unknown') {
      return 'Unknown';
    }

    try {
      // Try to parse the date string
      DateTime dateTime;
      if (dateString.contains('/')) {
        // Format: DD/MM/YYYY or similar
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          dateTime = DateTime(year, month, day);
        } else {
          return dateString; // Return original if can't parse
        }
      } else {
        // Try to parse as ISO string or other format
        dateTime = DateTime.parse(dateString);
      }

      return formatTimeAgo(dateTime);
    } catch (e) {
      return dateString; // Return original if can't parse
    }
  }

  Icon getFoodTypeIcon(String type) {
    switch (type) {
      case 'veg':
        return Icon(Icons.dining_outlined, color: Colors.green);
      case 'nonveg':
        return Icon(Icons.dining_outlined, color: Colors.red);
      case 'vegan':
        return Icon(Icons.eco_outlined, color: Colors.teal);
      default:
        return Icon(Icons.help_outline);
    }
  }

  Widget getDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        chipColor = Colors.green;
        break;
      case 'medium':
        chipColor = Colors.orange;
        break;
      case 'hard':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: StatefulBuilder(
      builder: (context, setState) {
        return GridView.builder(
          itemCount: recipes.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            final recipeId = recipe['id'] ?? recipe['recipeId'] ?? '';
            final isSaved = isRecipeSaved(recipeId);

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section
                  Expanded(
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            recipe['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://us.123rf.com/450wm/yupiramos/yupiramos2208/yupiramos220802258/189948846-recipe-with-vegetables.jpg?ver=6',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          // Category badge
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                recipe['category'] ?? 'Recipe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Info Section
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['title'] ?? recipe['name'] ?? 'Recipe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Uploaded: ${formatTimeAgoFromString(recipe['createdAt'])}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getDifficultyChip(recipe['difficulty'] ?? 'Easy'),
                              getFoodTypeIcon(
                                recipe['type'] ?? recipe['diet'] ?? 'veg',
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recipe['type'] ??
                                    recipe['diet'] ??
                                    'Vegetarian',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  if (showDelete) {
                                    // Handle delete
                                    onRecipeDeleted?.call(recipeId);
                                  } else {
                                    // Handle save/unsave with immediate UI update
                                    toggleSavedRecipe(recipeId);
                                    setState(
                                      () {},
                                    ); // This triggers immediate UI update
                                    onSavedChanged?.call();
                                  }
                                },
                                icon: showDelete
                                    ? Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      )
                                    : Icon(
                                        isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isSaved
                                            ? Colors.brown[700]
                                            : Colors.brown,
                                        size: 20,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
