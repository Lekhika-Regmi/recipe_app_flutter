// lib/models/recipe_model.dart

class Recipe {
  final String recipeId;
  final String userId;
  final String title;
  final RecipeCategory category;
  final DietType diet;
  final Difficulty difficulty;
  final List<String> ingredients;
  final List<String> instructions;
  final String? image;
  final DateTime createdAt;

  Recipe({
    required this.recipeId,
    required this.userId,
    required this.title,
    required this.category,
    required this.diet,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    this.image,
    required this.createdAt,
  });

  // Convert JSON to Recipe object
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipe_id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      category: _getCategoryFromString(json['category'] ?? ''),
      diet: _getDietFromString(json['diet'] ?? ''),
      difficulty: _getDifficultyFromString(json['difficulty'] ?? ''),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      image: json['image'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Convert Recipe object to JSON
  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'user_id': userId,
      'title': title,
      'category': category.name,
      'diet': diet.name,
      'difficulty': difficulty.name,
      'ingredients': ingredients,
      'instructions': instructions,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Static helper methods for enum conversion
  static RecipeCategory _getCategoryFromString(String category) {
    switch (category.toUpperCase()) {
      case 'BREAKFAST':
        return RecipeCategory.BREAKFAST;
      case 'LUNCH':
        return RecipeCategory.LUNCH;
      case 'DINNER':
        return RecipeCategory.DINNER;
      case 'MAIN_COURSE':
        return RecipeCategory.MAIN_COURSE;
      case 'APPETIZER':
        return RecipeCategory.APPETIZER;
      case 'DESSERT':
        return RecipeCategory.DESSERT;
      case 'SNACK':
        return RecipeCategory.SNACK;
      case 'SALAD':
        return RecipeCategory.SALAD;
      case 'SOUP':
        return RecipeCategory.SOUP;
      case 'BEVERAGE':
        return RecipeCategory.BEVERAGE;
      default:
        return RecipeCategory.MAIN_COURSE;
    }
  }

  static DietType _getDietFromString(String diet) {
    switch (diet.toUpperCase()) {
      case 'VEGETARIAN':
        return DietType.VEGETARIAN;
      case 'VEGAN':
        return DietType.VEGAN;
      case 'NON_VEGETARIAN':
        return DietType.NON_VEGETARIAN;
      case 'GLUTEN_FREE':
        return DietType.GLUTEN_FREE;
      case 'KETO':
        return DietType.KETO;
      case 'PALEO':
        return DietType.PALEO;
      default:
        return DietType.VEGETARIAN;
    }
  }

  static Difficulty _getDifficultyFromString(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'EASY':
        return Difficulty.EASY;
      case 'MEDIUM':
        return Difficulty.MEDIUM;
      case 'HARD':
        return Difficulty.HARD;
      default:
        return Difficulty.EASY;
    }
  }
}

// Enums for better type safety
enum RecipeCategory {
  BREAKFAST,
  LUNCH,
  DINNER,
  MAIN_COURSE,
  APPETIZER,
  DESSERT,
  SNACK,
  SALAD,
  SOUP,
  BEVERAGE,
}

enum DietType { VEGETARIAN, VEGAN, NON_VEGETARIAN, GLUTEN_FREE, KETO, PALEO }

enum Difficulty { EASY, MEDIUM, HARD }

// Extension methods for better display
extension RecipeCategoryExtension on RecipeCategory {
  String get displayName {
    switch (this) {
      case RecipeCategory.BREAKFAST:
        return 'Breakfast';
      case RecipeCategory.LUNCH:
        return 'Lunch';
      case RecipeCategory.DINNER:
        return 'Dinner';
      case RecipeCategory.MAIN_COURSE:
        return 'Main Course';
      case RecipeCategory.APPETIZER:
        return 'Appetizer';
      case RecipeCategory.DESSERT:
        return 'Dessert';
      case RecipeCategory.SNACK:
        return 'Snack';
      case RecipeCategory.SALAD:
        return 'Salad';
      case RecipeCategory.SOUP:
        return 'Soup';
      case RecipeCategory.BEVERAGE:
        return 'Beverage';
    }
  }
}

extension DietTypeExtension on DietType {
  String get displayName {
    switch (this) {
      case DietType.VEGETARIAN:
        return 'Vegetarian';
      case DietType.VEGAN:
        return 'Vegan';
      case DietType.NON_VEGETARIAN:
        return 'Non-Vegetarian';
      case DietType.GLUTEN_FREE:
        return 'Gluten Free';
      case DietType.KETO:
        return 'Keto';
      case DietType.PALEO:
        return 'Paleo';
    }
  }
}

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.EASY:
        return 'Easy';
      case Difficulty.MEDIUM:
        return 'Medium';
      case Difficulty.HARD:
        return 'Hard';
    }
  }
}
