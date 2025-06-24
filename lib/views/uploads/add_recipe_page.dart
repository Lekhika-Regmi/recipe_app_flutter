import 'package:flutter/material.dart';

import '../../models/recipe_model.dart';
import '../../services/api_service.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _instructionController = TextEditingController();

  final ApiService _apiService = ApiService();

  RecipeCategory _selectedCategory = RecipeCategory.MAIN_COURSE;
  DietType _selectedDiet = DietType.VEGETARIAN;
  Difficulty _selectedDifficulty = Difficulty.EASY;

  List<String> _ingredients = [];
  List<String> _instructions = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _ingredientController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addInstruction() {
    if (_instructionController.text.trim().isNotEmpty) {
      setState(() {
        _instructions.add(_instructionController.text.trim());
        _instructionController.clear();
      });
    }
  }

  void _removeInstruction(int index) {
    setState(() {
      _instructions.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one ingredient'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one instruction'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.createRecipe(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        diet: _selectedDiet,
        difficulty: _selectedDifficulty,
        ingredients: _ingredients,
        instructions: _instructions,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe created successfully!'),
            backgroundColor: Colors.brown,
          ),
        );

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create recipe: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Recipe',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   if (_isLoading)
        //     const Center(
        //       child: Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: SizedBox(
        //           width: 20,
        //           height: 20,
        //           child: CircularProgressIndicator(strokeWidth: 2),
        //         ),
        //       ),
        //     )
        //   else
        //     Container(
        //       margin: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
        //       // child: ElevatedButton(
        //       //   onPressed: _saveRecipe,
        //       //   style: ElevatedButton.styleFrom(
        //       //     backgroundColor: Colors.brown[600],
        //       //     foregroundColor: Colors.white,
        //       //     elevation: 0,
        //       //     shape: RoundedRectangleBorder(
        //       //       borderRadius: BorderRadius.circular(12),
        //       //     ),
        //       //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //       //   ),
        //       //   child: const Text(
        //       //     'Save',
        //       //     style: TextStyle(fontWeight: FontWeight.w600),
        //       //   ),
        //       // ),
        //     ),
        // ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Basic Information Section
              _buildSection(
                title: 'Basic Information',
                icon: Icons.info_outline,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Recipe Title',
                      hint: 'Enter your recipe name',
                      icon: Icons.restaurant_menu,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a recipe title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _imageUrlController,
                      label: 'Image URL',
                      hint: 'Add a photo URL (optional)',
                      icon: Icons.image_outlined,
                    ),
                  ],
                ),
              ),

              // Recipe Details Section
              _buildSection(
                title: 'Recipe Details',
                icon: Icons.tune,
                child: Column(
                  children: [
                    _buildDropdown<RecipeCategory>(
                      label: 'Category',
                      value: _selectedCategory,
                      icon: Icons.category_outlined,
                      items: RecipeCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategory = value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown<DietType>(
                      label: 'Diet Type',
                      value: _selectedDiet,
                      icon: Icons.eco_outlined,
                      items: DietType.values.map((diet) {
                        return DropdownMenuItem(
                          value: diet,
                          child: Text(diet.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedDiet = value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown<Difficulty>(
                      label: 'Difficulty Level',
                      value: _selectedDifficulty,
                      icon: Icons.speed_outlined,
                      items: Difficulty.values.map((difficulty) {
                        return DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedDifficulty = value!);
                      },
                    ),
                  ],
                ),
              ),

              // Ingredients Section
              _buildSection(
                title: 'Ingredients',
                icon: Icons.list_alt,
                subtitle: 'Add all ingredients needed for this recipe',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _ingredientController,
                            label: 'Add Ingredient',
                            hint: 'e.g., 2 cups flour',
                            icon: Icons.add_circle_outline,
                            onFieldSubmitted: (_) => _addIngredient(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          onPressed: _addIngredient,
                          label: 'Add',
                          icon: Icons.add,
                        ),
                      ],
                    ),
                    if (_ingredients.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildItemsList(
                        items: _ingredients,
                        onRemove: _removeIngredient,
                        emptyMessage: 'No ingredients added yet',
                      ),
                    ],
                  ],
                ),
              ),

              // Instructions Section
              _buildSection(
                title: 'Instructions',
                icon: Icons.format_list_numbered,
                subtitle: 'Step-by-step cooking instructions',
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _instructionController,
                            label: 'Add Instruction',
                            hint: 'Describe the cooking step',
                            icon: Icons.note_add_outlined,
                            maxLines: 3,
                            onFieldSubmitted: (_) => _addInstruction(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _buildActionButton(
                            onPressed: _addInstruction,
                            label: 'Add',
                            icon: Icons.add,
                          ),
                        ),
                      ],
                    ),
                    if (_instructions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildItemsList(
                        items: _instructions,
                        onRemove: _removeInstruction,
                        emptyMessage: 'No instructions added yet',
                      ),
                    ],
                  ],
                ),
              ),

              // Recipe Summary
              if (_ingredients.isNotEmpty || _instructions.isNotEmpty)
                _buildSection(
                  title: 'Recipe Summary',
                  icon: Icons.summarize_outlined,
                  child: _buildSummaryCard(),
                ),

              // Save Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Creating Recipe...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Create Recipe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.brown[600], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown[600]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown[600]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildItemsList({
    required List<String> items,
    required void Function(int) onRemove,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey[200]),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.brown[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.brown[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            title: Text(
              items[index],
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
              onPressed: () => onRemove(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: _selectedCategory.displayName,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.eco_outlined,
                  label: 'Diet',
                  value: _selectedDiet.displayName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.speed_outlined,
                  label: 'Difficulty',
                  value: _selectedDifficulty.displayName,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.format_list_numbered,
                  label: 'Steps',
                  value: '${_instructions.length}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            icon: Icons.list_alt,
            label: 'Ingredients',
            value: '${_ingredients.length} items',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.brown[700]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.brown[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
