// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'recipe.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// _Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
//   recipeId: json['recipeId'] as String,
//   userId: json['userId'] as String,
//   title: json['title'] as String,
//   category: $enumDecode(_$RecipeCategoryEnumMap, json['category']),
//   diet: $enumDecode(_$DietTypeEnumMap, json['diet']),
//   difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
//   ingredients: (json['ingredients'] as List<dynamic>)
//       .map((e) => e as String)
//       .toList(),
//   instructions: (json['instructions'] as List<dynamic>)
//       .map((e) => e as String)
//       .toList(),
//   image: json['image'] as String?,
//   createdAt: DateTime.parse(json['createdAt'] as String),
// );
//
// Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
//   'recipeId': instance.recipeId,
//   'userId': instance.userId,
//   'title': instance.title,
//   'category': _$RecipeCategoryEnumMap[instance.category]!,
//   'diet': _$DietTypeEnumMap[instance.diet]!,
//   'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
//   'ingredients': instance.ingredients,
//   'instructions': instance.instructions,
//   'image': instance.image,
//   'createdAt': instance.createdAt.toIso8601String(),
// };
//
// const _$RecipeCategoryEnumMap = {
//   RecipeCategory.BREAKFAST: 'BREAKFAST',
//   RecipeCategory.LUNCH: 'LUNCH',
//   RecipeCategory.DINNER: 'DINNER',
//   RecipeCategory.MAIN_COURSE: 'MAIN_COURSE',
//   RecipeCategory.APPETIZER: 'APPETIZER',
//   RecipeCategory.DESSERT: 'DESSERT',
//   RecipeCategory.SNACK: 'SNACK',
//   RecipeCategory.SALAD: 'SALAD',
//   RecipeCategory.SOUP: 'SOUP',
//   RecipeCategory.BEVERAGE: 'BEVERAGE',
// };
//
// const _$DietTypeEnumMap = {
//   DietType.VEGETARIAN: 'VEGETARIAN',
//   DietType.VEGAN: 'VEGAN',
//   DietType.NON_VEGETARIAN: 'NON_VEGETARIAN',
//   DietType.GLUTEN_FREE: 'GLUTEN_FREE',
//   DietType.KETO: 'KETO',
//   DietType.PALEO: 'PALEO',
// };
//
// const _$DifficultyEnumMap = {
//   Difficulty.EASY: 'EASY',
//   Difficulty.MEDIUM: 'MEDIUM',
//   Difficulty.HARD: 'HARD',
// };
