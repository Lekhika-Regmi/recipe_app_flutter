// // dart format width=80
// // coverage:ignore-file
// // GENERATED CODE - DO NOT MODIFY BY HAND
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
//
// part of 'recipe.dart';
//
// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************
//
// // dart format off
// T _$identity<T>(T value) => value;
//
// /// @nodoc
// mixin _$Recipe {
//
//  String get recipeId; String get userId; String get title; RecipeCategory get category; DietType get diet; Difficulty get difficulty; List<String> get ingredients; List<String> get instructions; String? get image; DateTime get createdAt;
// /// Create a copy of Recipe
// /// with the given fields replaced by the non-null parameter values.
// @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// $RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);
//
//   /// Serializes this Recipe to a JSON map.
//   Map<String, dynamic> toJson();
//
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.diet, diet) || other.diet == diet)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.instructions, instructions)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,recipeId,userId,title,category,diet,difficulty,const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(instructions),image,createdAt);
//
// @override
// String toString() {
//   return 'Recipe(recipeId: $recipeId, userId: $userId, title: $title, category: $category, diet: $diet, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, image: $image, createdAt: $createdAt)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class $RecipeCopyWith<$Res>  {
//   factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
// @useResult
// $Res call({
//  String recipeId, String userId, String title, RecipeCategory category, DietType diet, Difficulty difficulty, List<String> ingredients, List<String> instructions, String? image, DateTime createdAt
// });
//
//
//
//
// }
// /// @nodoc
// class _$RecipeCopyWithImpl<$Res>
//     implements $RecipeCopyWith<$Res> {
//   _$RecipeCopyWithImpl(this._self, this._then);
//
//   final Recipe _self;
//   final $Res Function(Recipe) _then;
//
// /// Create a copy of Recipe
// /// with the given fields replaced by the non-null parameter values.
// @pragma('vm:prefer-inline') @override $Res call({Object? recipeId = null,Object? userId = null,Object? title = null,Object? category = null,Object? diet = null,Object? difficulty = null,Object? ingredients = null,Object? instructions = null,Object? image = freezed,Object? createdAt = null,}) {
//   return _then(_self.copyWith(
// recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
// as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
// as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
// as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
// as RecipeCategory,diet: null == diet ? _self.diet : diet // ignore: cast_nullable_to_non_nullable
// as DietType,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
// as Difficulty,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
// as List<String>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
// as List<String>,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
// as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
// as DateTime,
//   ));
// }
//
// }
//
//
// /// @nodoc
// @JsonSerializable()
//
// class _Recipe implements Recipe {
//   const _Recipe({required this.recipeId, required this.userId, required this.title, required this.category, required this.diet, required this.difficulty, required final  List<String> ingredients, required final  List<String> instructions, this.image, required this.createdAt}): _ingredients = ingredients,_instructions = instructions;
//   factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
//
// @override final  String recipeId;
// @override final  String userId;
// @override final  String title;
// @override final  RecipeCategory category;
// @override final  DietType diet;
// @override final  Difficulty difficulty;
//  final  List<String> _ingredients;
// @override List<String> get ingredients {
//   if (_ingredients is EqualUnmodifiableListView) return _ingredients;
//   // ignore: implicit_dynamic_type
//   return EqualUnmodifiableListView(_ingredients);
// }
//
//  final  List<String> _instructions;
// @override List<String> get instructions {
//   if (_instructions is EqualUnmodifiableListView) return _instructions;
//   // ignore: implicit_dynamic_type
//   return EqualUnmodifiableListView(_instructions);
// }
//
// @override final  String? image;
// @override final  DateTime createdAt;
//
// /// Create a copy of Recipe
// /// with the given fields replaced by the non-null parameter values.
// @override @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// _$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);
//
// @override
// Map<String, dynamic> toJson() {
//   return _$RecipeToJson(this, );
// }
//
// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.diet, diet) || other.diet == diet)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._instructions, _instructions)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
// }
//
// @JsonKey(includeFromJson: false, includeToJson: false)
// @override
// int get hashCode => Object.hash(runtimeType,recipeId,userId,title,category,diet,difficulty,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_instructions),image,createdAt);
//
// @override
// String toString() {
//   return 'Recipe(recipeId: $recipeId, userId: $userId, title: $title, category: $category, diet: $diet, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, image: $image, createdAt: $createdAt)';
// }
//
//
// }
//
// /// @nodoc
// abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
//   factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
// @override @useResult
// $Res call({
//  String recipeId, String userId, String title, RecipeCategory category, DietType diet, Difficulty difficulty, List<String> ingredients, List<String> instructions, String? image, DateTime createdAt
// });
//
//
//
//
// }
// /// @nodoc
// class __$RecipeCopyWithImpl<$Res>
//     implements _$RecipeCopyWith<$Res> {
//   __$RecipeCopyWithImpl(this._self, this._then);
//
//   final _Recipe _self;
//   final $Res Function(_Recipe) _then;
//
// /// Create a copy of Recipe
// /// with the given fields replaced by the non-null parameter values.
// @override @pragma('vm:prefer-inline') $Res call({Object? recipeId = null,Object? userId = null,Object? title = null,Object? category = null,Object? diet = null,Object? difficulty = null,Object? ingredients = null,Object? instructions = null,Object? image = freezed,Object? createdAt = null,}) {
//   return _then(_Recipe(
// recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
// as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
// as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
// as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
// as RecipeCategory,diet: null == diet ? _self.diet : diet // ignore: cast_nullable_to_non_nullable
// as DietType,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
// as Difficulty,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
// as List<String>,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
// as List<String>,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
// as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
// as DateTime,
//   ));
// }
//
//
// }
//
// // dart format on
