import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/recipe_card.dart';

import '../../data/recipe_data.dart';
import 'add_recipe_page.dart';

class UploadsPage extends StatelessWidget {
  const UploadsPage({super.key});

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

      body: recipeCard(uploadedRecipes, showDelete: true),
    );
  }
}
