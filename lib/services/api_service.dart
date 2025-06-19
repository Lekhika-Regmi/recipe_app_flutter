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

  // ✅ Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      return 'Error: ${error.response?.statusCode} - ${error.response?.statusMessage}';
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
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
