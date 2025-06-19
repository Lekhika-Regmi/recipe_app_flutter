import 'package:flutter/material.dart';

import '../../data/recipe_data.dart';
import '../../widgets/recipe_card_new.dart';
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

      body: recipeCardNew(uploadedRecipes, showDelete: true),
    );
  }
}
