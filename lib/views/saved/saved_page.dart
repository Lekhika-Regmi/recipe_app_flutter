import 'package:flutter/material.dart';

import '../../data/recipe_data.dart';
import '../../widgets/recipe_card_new.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    // Get all saved recipes using the correct function name
    final savedRecipes = getSavedRecipesList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: savedRecipes.isEmpty
          ? Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.brown[300], fontSize: 18),
                  children: [
                    TextSpan(text: 'You have not saved anything yet!!!\n'),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.bookmark_outline,
                        color: Colors.brown[300],
                        size: 24,
                      ),
                    ),
                    TextSpan(text: '\nPress '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.bookmark_border,
                        color: Colors.brown[400],
                        size: 16,
                      ),
                    ),
                    TextSpan(text: ' button to save recipes.'),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Saved Recipes (${savedRecipes.length})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: recipeCardNew(
                      savedRecipes,
                      showDelete: false,
                      onSavedChanged: () {
                        // Refresh the saved page when bookmark is toggled
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
