import 'package:flutter/material.dart';

Widget recipeCard(
  List<Map<String, dynamic>> recipes, {
  bool showDelete = false,
}) {
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

  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: GridView.builder(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    recipe['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://us.123rf.com/450wm/yupiramos/yupiramos2208/yupiramos220802258/189948846-recipe-with-vegetables.jpg?ver=6',
                        fit: BoxFit.cover,
                      );
                    },
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
                    children: [
                      Text(
                        recipe['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Uploaded: ${recipe['date']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getFoodTypeIcon(recipe['type']),
                          IconButton(
                            onPressed: () {
                              // You can implement your logic here
                            },
                            icon: showDelete
                                ? Icon(Icons.delete, color: Colors.red)
                                : Icon(
                                    Icons.bookmark_border,
                                    color: Colors.brown,
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
    ),
  );
}
