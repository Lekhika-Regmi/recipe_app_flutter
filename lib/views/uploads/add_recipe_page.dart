import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add New Recipe')),
        backgroundColor: Colors.brown[200],
      ),
      body: Column(
        children: [
          //image upload area
          Container(
            color: Colors.deepOrangeAccent[100],
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add_a_photo),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          ),
          Divider(
            height: 5,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.brown,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // cursorColor: Theme.of(context).cursorColor,
              initialValue: 'Input text',
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.edit_note, color: Colors.brown[600]),
                labelText: 'Recipe Name',
                //  labelStyle: TextStyle(color: Color(0xFF6200EE)),
                // helperText: 'Helper text',
                // suffixIcon: Icon(Icons.check_circle),
                enabledBorder: UnderlineInputBorder(
                  //  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
