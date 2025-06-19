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

  @override
  void initState() {
    super.initState();
    fetchUploadedRecipes();
  }

  Future<void> fetchUploadedRecipes() async {
    try {
      // You can add a query like `?userId=1` if needed in backend
      final recipes = await ApiService().getAllRecipes();
      setState(() {
        _uploadedRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading uploaded recipes: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipePage()),
          );
        },
        tooltip: 'Add Recipe',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _uploadedRecipes.isEmpty
          ? const Center(
              child: Text(
                'Upload or share your recipe',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            )
          : recipeCardNew(_uploadedRecipes, showDelete: true),
    );
  }
}
