import 'package:dio/dio.dart';

import '../models/recipe_model.dart';

class ApiService {
  late Dio _dio;
  // static const String _baseUrl = 'http://localhost:3000';
  final String _baseUrl = 'http://10.0.2.2:3000';
  static const String _recipesEndpoint = '/recipes';

  // Current user ID - you can manage this through a user service or shared preferences
  static String currentUserId = '2'; // Set to user 2 for testing

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  // ✅ Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await _dio.get(_recipesEndpoint);
      final data = response.data;

      final List<dynamic> rawRecipes = data['recipes'];
      return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get 'For You' recipes (excluding current user's recipes)
  Future<List<Recipe>> getForYouRecipes() async {
    try {
      final response = await _dio.get('$_recipesEndpoint/for-you');
      final data = response.data;

      final List<dynamic> rawRecipes = data['forYouRecipes'];
      final allRecipes = rawRecipes
          .map((json) => Recipe.fromJson(json))
          .toList();

      // Filter out current user's recipes for "For You" section
      return allRecipes
          .where((recipe) => recipe.userId != currentUserId)
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get current user's uploaded recipes
  Future<List<Recipe>> getUserRecipes([String? userId]) async {
    try {
      final targetUserId = userId ?? currentUserId;
      final response = await _dio.get('$_recipesEndpoint/user/$targetUserId');

      final data = response.data;

      if (data is List) {
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        final List<dynamic> rawRecipes =
            data['recipes'] ?? data['userRecipes'] ?? [];
        return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        // Fallback: filter all recipes by user ID
        final allRecipes = await getAllRecipes();
        return allRecipes
            .where((recipe) => recipe.userId == targetUserId)
            .toList();
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Create a new recipe
  Future<Recipe> createRecipe({
    required String title,
    required RecipeCategory category,
    required DietType diet,
    required Difficulty difficulty,
    required List<String> ingredients,
    required List<String> instructions,
    String? imageUrl,
  }) async {
    try {
      final recipeData = {
        'user_id': currentUserId,
        'title': title,
        'category': category.name,
        'diet': diet.name,
        'difficulty': difficulty.name,
        'ingredients': ingredients,
        'instructions': instructions,
        'image': imageUrl,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(_recipesEndpoint, data: recipeData);

      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Update an existing recipe (only if current user owns it)
  Future<Recipe> updateRecipe({
    required String recipeId,
    required String title,
    required RecipeCategory category,
    required DietType diet,
    required Difficulty difficulty,
    required List<String> ingredients,
    required List<String> instructions,
    String? imageUrl,
  }) async {
    try {
      final recipeData = {
        'title': title,
        'category': category.name,
        'diet': diet.name,
        'difficulty': difficulty.name,
        'ingredients': ingredients,
        'instructions': instructions,
        'image': imageUrl,
      };

      final response = await _dio.put(
        '$_recipesEndpoint/$recipeId',
        data: recipeData,
        queryParameters: {
          'userId': currentUserId,
        }, // Ensure only owner can update
      );

      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Delete a recipe (only if current user owns it)
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _dio.delete(
        '$_recipesEndpoint/$recipeId',
        queryParameters: {
          'userId': currentUserId,
        }, // Ensure only owner can delete
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get recipe by ID
  Future<Recipe> getRecipeById(String id) async {
    try {
      final response = await _dio.get('$_recipesEndpoint/$id');
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Search recipes by query
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await _dio.get(
        '$_recipesEndpoint/search',
        queryParameters: {'q': query, 'limit': 20},
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        final List<dynamic> rawRecipes =
            data['recipes'] ?? data['results'] ?? data['data'] ?? [];
        return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get recipes by category
  Future<List<Recipe>> getRecipesByCategory(RecipeCategory category) async {
    try {
      final response = await _dio.get(
        '$_recipesEndpoint/category/${category.name.toLowerCase()}',
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        final List<dynamic> rawRecipes = data['recipes'] ?? data['data'] ?? [];
        return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get trending/popular recipes
  Future<List<Recipe>> getTrendingRecipes({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '$_recipesEndpoint/trending',
        queryParameters: {'limit': limit},
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        final List<dynamic> rawRecipes =
            data['recipes'] ?? data['trending'] ?? data['data'] ?? [];
        return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Set current user (for testing different users)
  void setCurrentUser(String userId) {
    currentUserId = userId;
  }

  // ✅ Get current user ID
  String getCurrentUserId() {
    return currentUserId;
  }

  // ✅ Check if current user owns a recipe
  bool isCurrentUserRecipe(Recipe recipe) {
    return recipe.userId == currentUserId;
  }

  // ✅ Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          return 'Invalid request. Please check your input.';
        case 401:
          return 'Unauthorized. Please check your credentials.';
        case 403:
          return 'You don\'t have permission to perform this action.';
        case 404:
          return 'Recipe not found.';
        case 409:
          return 'Recipe already exists or conflict occurred.';
        case 422:
          return 'Invalid data provided. Please check your input.';
        case 429:
          return 'Too many requests. Please wait a moment and try again.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return 'Error: ${error.response?.statusCode} - ${error.response?.statusMessage}';
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';
      case DioExceptionType.badResponse:
        return 'Bad server response.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
