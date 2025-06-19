import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:3000';
  // Note: Use 'http://10.0.2.2:3000' for Android emulator
  // Use your computer's IP address for real device testing

  // Constructor to set up Dio with basic configuration
  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print('DIO LOG: $object'),
      ),
    );
  }

  // Check if server is running
  Future<String> checkServerStatus() async {
    try {
      final response = await _dio.get("/recipes");
      // Since your JSON has a "status" field, let's extract it
      if (response.data != null && response.data['status'] != null) {
        return response.data['status'];
      }
      return "Server is running";
    } catch (e) {
      print('Server check error: $e');
      return "Server not reachable: $e";
    }
  }

  // Fetch all recipes from your Mockoon server
  Future<Map<String, dynamic>> fetchAllRecipes() async {
    try {
      final response = await _dio.get('/recipes');
      if (response.statusCode == 200) {
        print('API Response: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout - check if Mockoon server is running',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Error fetching recipes: $e');
    }
  }

  // Get specific recipe categories
  Future<List<Map<String, dynamic>>> getUploadedRecipes() async {
    try {
      final allData = await fetchAllRecipes();
      return List<Map<String, dynamic>>.from(allData['uploadedRecipes'] ?? []);
    } catch (e) {
      throw Exception('Error fetching uploaded recipes: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getForYouRecipes() async {
    try {
      final allData = await fetchAllRecipes();
      return List<Map<String, dynamic>>.from(allData['forYouRecipes'] ?? []);
    } catch (e) {
      throw Exception('Error fetching for you recipes: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSavedRecipes() async {
    try {
      final allData = await fetchAllRecipes();
      return List<Map<String, dynamic>>.from(allData['savedRecipes'] ?? []);
    } catch (e) {
      throw Exception('Error fetching saved recipes: $e');
    }
  }

  // Get recipes by type (veg, nonveg, vegan)
  Future<List<Map<String, dynamic>>> getRecipesByType(String type) async {
    try {
      final allData = await fetchAllRecipes();
      List<Map<String, dynamic>> allRecipes = [];

      // Combine all recipe lists
      allRecipes.addAll(
        List<Map<String, dynamic>>.from(allData['uploadedRecipes'] ?? []),
      );
      allRecipes.addAll(
        List<Map<String, dynamic>>.from(allData['forYouRecipes'] ?? []),
      );
      allRecipes.addAll(
        List<Map<String, dynamic>>.from(allData['savedRecipes'] ?? []),
      );

      // Filter by type
      return allRecipes
          .where(
            (recipe) =>
                recipe['type']?.toString().toLowerCase() == type.toLowerCase(),
          )
          .toList();
    } catch (e) {
      throw Exception('Error fetching recipes by type: $e');
    }
  }
}
