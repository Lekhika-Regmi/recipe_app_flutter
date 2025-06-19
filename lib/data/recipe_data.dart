// lib/data/recipe_data.dart
import '../models/recipe_model.dart';

// Sample JSON response (this will come from your API later)
const Map<String, dynamic> sampleApiResponse = {
  "status": "Server is running",
  "recipes": [
    {
      "recipe_id": "rec_001",
      "user_id": "1",
      "title": "Paneer Tikka",
      "category": "MAIN_COURSE",
      "diet": "VEGETARIAN",
      "difficulty": "MEDIUM",
      "ingredients": [
        "500g paneer cubes",
        "1 cup yogurt",
        "2 tsp ginger-garlic paste",
        "1 tsp red chili powder",
        "1 tsp garam masala",
        "1 tsp cumin powder",
        "2 tbsp oil",
        "Salt to taste",
        "Bell peppers and onions for grilling",
      ],
      "instructions": [
        "Cut paneer into cubes and marinate with yogurt and spices for 30 minutes",
        "Thread paneer, bell peppers, and onions onto skewers",
        "Grill or bake at 200°C for 15-20 minutes, turning occasionally",
        "Serve hot with mint chutney and lemon wedges",
      ],
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjU3AT9r8228is-t5JHuLCk2InG0PID_mpRw&s",
      "createdAt": "2025-06-11T10:30:00Z",
    },
    {
      "recipe_id": "rec_002",
      "user_id": "1",
      "title": "Chicken Butter Masala",
      "category": "MAIN_COURSE",
      "diet": "NON_VEGETARIAN",
      "difficulty": "HARD",
      "ingredients": [
        "500g boneless chicken",
        "2 tbsp butter",
        "1 large onion, chopped",
        "3 tomatoes, pureed",
        "1 cup heavy cream",
        "2 tsp ginger-garlic paste",
        "1 tsp garam masala",
        "1 tsp red chili powder",
        "1 tsp cumin powder",
        "Salt to taste",
        "Fresh cilantro for garnish",
      ],
      "instructions": [
        "Marinate chicken with spices and cook until tender",
        "In a pan, melt butter and sauté onions until golden",
        "Add tomato puree and cook until oil separates",
        "Add cooked chicken and simmer for 10 minutes",
        "Stir in cream and garnish with cilantro before serving",
      ],
      "image":
          "https://i0.wp.com/www.nourishdeliciously.com/wp-content/uploads/2022/11/DSC_9207.jpg",
      "createdAt": "2025-06-10T14:15:00Z",
    },
    {
      "recipe_id": "rec_003",
      "user_id": "1",
      "title": "Vegan Salad",
      "category": "SALAD",
      "diet": "VEGAN",
      "difficulty": "EASY",
      "ingredients": [
        "2 cups mixed greens",
        "1 cucumber, diced",
        "2 tomatoes, chopped",
        "1 avocado, sliced",
        "1/4 cup red onion, thinly sliced",
        "2 tbsp olive oil",
        "1 tbsp lemon juice",
        "1 tsp balsamic vinegar",
        "Salt and pepper to taste",
        "2 tbsp pumpkin seeds",
      ],
      "instructions": [
        "Wash and prepare all vegetables",
        "In a large bowl, combine mixed greens, cucumber, tomatoes, and red onion",
        "Add sliced avocado on top",
        "Whisk together olive oil, lemon juice, and balsamic vinegar",
        "Drizzle dressing over salad and sprinkle with pumpkin seeds",
        "Season with salt and pepper before serving",
      ],
      "image":
          "https://www.noracooks.com/wp-content/uploads/2022/06/vegan-caesar-salad-4.jpg",
      "createdAt": "2025-06-09T12:45:00Z",
    },
  ],
  "forYouRecipes": [
    {
      "recipe_id": "rec_004",
      "user_id": "1",
      "title": "French Toast",
      "category": "BREAKFAST",
      "diet": "VEGETARIAN",
      "difficulty": "EASY",
      "ingredients": [
        "4 slices thick bread",
        "2 large eggs",
        "1/2 cup milk",
        "1 tsp vanilla extract",
        "1/2 tsp cinnamon",
        "2 tbsp butter",
        "Maple syrup for serving",
        "Powdered sugar for dusting",
      ],
      "instructions": [
        "Beat eggs, milk, vanilla, and cinnamon in a shallow dish",
        "Heat butter in a large skillet over medium heat",
        "Dip each bread slice in egg mixture, coating both sides",
        "Cook bread slices for 2-3 minutes per side until golden brown",
        "Serve hot with maple syrup and a dusting of powdered sugar",
      ],
      "image":
          "https://thecookiedoughdiaries.com/wp-content/uploads/2022/12/healthy-french-toast-13.jpg",
      "createdAt": "2025-06-08T08:20:00Z",
    },
    {
      "recipe_id": "rec_005",
      "user_id": "1",
      "title": "Churros",
      "category": "DESSERT",
      "diet": "VEGAN",
      "difficulty": "MEDIUM",
      "ingredients": [
        "1 cup water",
        "2 tbsp sugar",
        "1/2 tsp salt",
        "2 tbsp vegetable oil",
        "1 cup all-purpose flour",
        "Oil for frying",
        "1/2 cup sugar for coating",
        "1 tsp cinnamon for coating",
      ],
      "instructions": [
        "Heat water, sugar, salt, and oil in a saucepan until boiling",
        "Remove from heat and stir in flour until smooth",
        "Transfer mixture to a piping bag with star tip",
        "Heat oil to 375°F for frying",
        "Pipe churros directly into hot oil and fry until golden",
        "Roll in cinnamon sugar mixture while still warm",
      ],
      "image":
          "https://zhangcatherine.com/wp-content/uploads/2023/02/12001200-1.jpg",
      "createdAt": "2025-06-07T16:30:00Z",
    },
    {
      "recipe_id": "rec_006",
      "user_id": "1",
      "title": "Cheesy Chicken Wrap",
      "category": "LUNCH",
      "diet": "NON_VEGETARIAN",
      "difficulty": "EASY",
      "ingredients": [
        "2 large tortillas",
        "200g cooked chicken breast, sliced",
        "1/2 cup shredded cheese",
        "2 tbsp mayonnaise",
        "1 tomato, sliced",
        "Lettuce leaves",
        "1/4 red onion, sliced",
        "Salt and pepper to taste",
      ],
      "instructions": [
        "Warm tortillas in a dry pan or microwave",
        "Spread mayonnaise on each tortilla",
        "Layer chicken, cheese, tomato, lettuce, and onion",
        "Season with salt and pepper",
        "Roll tightly and cut in half to serve",
      ],
      "image":
          "https://nourishedbynic.com/wp-content/uploads/2024/07/chicken-salad-wrap.jpg",
      "createdAt": "2025-06-06T13:10:00Z",
    },
    {
      "recipe_id": "rec_007",
      "user_id": "1",
      "title": "Salmon Bowl",
      "category": "MAIN_COURSE",
      "diet": "NON_VEGETARIAN",
      "difficulty": "MEDIUM",
      "ingredients": [
        "2 salmon fillets",
        "1 cup cooked rice",
        "1 avocado, sliced",
        "1 cucumber, diced",
        "1 cup edamame",
        "2 tbsp soy sauce",
        "1 tbsp sesame oil",
        "1 tsp sriracha",
        "1 tbsp sesame seeds",
        "Nori sheets for garnish",
      ],
      "instructions": [
        "Season and cook salmon fillets until flaky",
        "Prepare rice according to package instructions",
        "Arrange rice in bowls and top with cooked salmon",
        "Add avocado, cucumber, and edamame around the bowl",
        "Mix soy sauce, sesame oil, and sriracha for dressing",
        "Drizzle dressing over bowl and garnish with sesame seeds and nori",
      ],
      "image":
          "https://simply-delicious-food.com/wp-content/uploads/2022/04/Spicy-salmon-rice-bowls5-500x500.jpg",
      "createdAt": "2025-06-05T19:45:00Z",
    },
  ],
  "savedRecipes": [
    {
      "recipe_id": "rec_008",
      "user_id": "1",
      "title": "Avocado Toast",
      "category": "BREAKFAST",
      "diet": "VEGAN",
      "difficulty": "EASY",
      "ingredients": [
        "2 slices whole grain bread",
        "1 ripe avocado",
        "1 tbsp lemon juice",
        "Salt and pepper to taste",
        "Red pepper flakes",
        "Cherry tomatoes for topping",
        "Hemp seeds (optional)",
      ],
      "instructions": [
        "Toast bread slices until golden brown",
        "Mash avocado with lemon juice, salt, and pepper",
        "Spread avocado mixture on toast",
        "Top with cherry tomatoes and red pepper flakes",
        "Sprinkle with hemp seeds if desired",
      ],
      "image":
          "https://www.allrecipes.com/thmb/H1mSgOExKFdto3PWLfC9aTgJmlI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/11699506-avocado-toast-4x3-ea45b882fb0c454a9ca31647d4fd3c01.jpg",
      "createdAt": "2025-06-04T09:15:00Z",
    },
    {
      "recipe_id": "rec_009",
      "user_id": "1",
      "title": "Egg Sandwich",
      "category": "BREAKFAST",
      "diet": "NON_VEGETARIAN",
      "difficulty": "EASY",
      "ingredients": [
        "2 slices bread",
        "2 large eggs",
        "2 tbsp butter",
        "1 slice cheese",
        "Salt and pepper to taste",
        "1 tbsp mayonnaise",
        "Lettuce leaves (optional)",
      ],
      "instructions": [
        "Toast bread slices lightly",
        "Scramble eggs with salt and pepper in butter",
        "Spread mayonnaise on one slice of toast",
        "Layer scrambled eggs and cheese",
        "Add lettuce if desired and top with second slice",
        "Cut diagonally and serve immediately",
      ],
      "image":
          "https://images.getrecipekit.com/20240829132941-recipe_kit_breakfast-20sandwich.jpg?width=650&quality=90&",
      "createdAt": "2025-06-03T07:30:00Z",
    },
  ],
};

// Convert JSON data to Recipe objects
List<Recipe> get uploadedRecipes {
  return (sampleApiResponse['recipes'] as List)
      .map((json) => Recipe.fromJson(json))
      .toList();
}

List<Recipe> get forYouRecipes {
  return (sampleApiResponse['forYouRecipes'] as List)
      .map((json) => Recipe.fromJson(json))
      .toList();
}

List<Recipe> get savedRecipes {
  return (sampleApiResponse['savedRecipes'] as List)
      .map((json) => Recipe.fromJson(json))
      .toList();
}

// For backward compatibility with existing code
List<Map<String, dynamic>> get uploadedRecipesOldFormat {
  return uploadedRecipes.map((recipe) => recipe.toOldFormat()).toList();
}

List<Map<String, dynamic>> get forYouRecipesOldFormat {
  return forYouRecipes.map((recipe) => recipe.toOldFormat()).toList();
}

List<Map<String, dynamic>> get savedRecipesOldFormat {
  return savedRecipes.map((recipe) => recipe.toOldFormat()).toList();
}

// Global saved recipes list (in-memory storage for now)
Set<String> _savedRecipeIds = <String>{};

// Helper functions for saved recipes functionality
bool isRecipeSaved(String recipeId) {
  return _savedRecipeIds.contains(recipeId);
}

void toggleSavedRecipe(String recipeId) {
  if (_savedRecipeIds.contains(recipeId)) {
    _savedRecipeIds.remove(recipeId);
  } else {
    _savedRecipeIds.add(recipeId);
  }
}

List<Recipe> getSavedRecipesList() {
  // Get all recipes from all categories
  List<Recipe> allRecipes = [
    ...uploadedRecipes,
    ...forYouRecipes,
    ...savedRecipes,
  ];

  // Filter saved recipes
  return allRecipes
      .where((recipe) => _savedRecipeIds.contains(recipe.recipeId))
      .toList();
}
