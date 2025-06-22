import 'package:dio/dio.dart';

import '../models/recipe_model.dart';

class ApiService {
  late Dio _dio;
  static const String _baseUrl =
      'http://localhost:3000'; // Updated to remove /recipes
  static const String _recipesEndpoint = '/recipes';

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

    // _dio.interceptors.add(
    //   // LogInterceptor(
    //   //   requestBody: true,
    //   //   responseBody: true,
    //   //   //   logPrint: (obj) => print(obj),
    //   // ),
    // );
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

  // ✅ Get 'For You' recipes
  Future<List<Recipe>> getForYouRecipes() async {
    try {
      final response = await _dio.get('$_recipesEndpoint/for-you');
      final data = response.data;

      final List<dynamic> rawRecipes = data['forYouRecipes'];
      return rawRecipes.map((json) => Recipe.fromJson(json)).toList();
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
        queryParameters: {
          'q': query,
          'limit': 20, // Optional: limit results
        },
      );

      final data = response.data;

      // Handle different possible response structures
      if (data is List) {
        // If response is directly a list of recipes
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        // If response is wrapped in an object
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

  // ✅ Advanced search with filters (optional)
  Future<List<Recipe>> searchRecipesWithFilters({
    required String query,
    RecipeCategory? category,
    int? maxPrepTime,
    int? maxServings,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'q': query, 'limit': limit};

      // Add optional filters
      if (category != null) {
        queryParams['category'] = category.name.toLowerCase();
      }
      if (maxPrepTime != null) {
        queryParams['maxPrepTime'] = maxPrepTime;
      }
      if (maxServings != null) {
        queryParams['maxServings'] = maxServings;
      }

      final response = await _dio.get(
        '$_recipesEndpoint/search',
        queryParameters: queryParams,
      );

      final data = response.data;

      // Handle different possible response structures
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

  // ✅ Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      // Handle specific HTTP status codes
      switch (error.response?.statusCode) {
        case 400:
          return 'Invalid search query. Please try again.';
        case 404:
          return 'No recipes found matching your search.';
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
