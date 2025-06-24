// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'recipe.freezed.dart';
// part 'recipe.g.dart';
//
// @freezed
// class Recipe with _$Recipe {
//   const factory Recipe({
//     required String recipeId,
//     required String userId,
//     required String title,
//     required RecipeCategory category,
//     required DietType diet,
//     required Difficulty difficulty,
//     required List<String> ingredients,
//     required List<String> instructions,
//     String? image,
//     required DateTime createdAt,
//   }) = _Recipe;
//
//   factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
// }
//
// @JsonEnum()
// enum RecipeCategory {
//   BREAKFAST,
//   LUNCH,
//   DINNER,
//   MAIN_COURSE,
//   APPETIZER,
//   DESSERT,
//   SNACK,
//   SALAD,
//   SOUP,
//   BEVERAGE,
// }
//
// @JsonEnum()
// enum DietType { VEGETARIAN, VEGAN, NON_VEGETARIAN, GLUTEN_FREE, KETO, PALEO }
//
// @JsonEnum()
// enum Difficulty { EASY, MEDIUM, HARD }
