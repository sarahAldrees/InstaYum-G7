import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index);

  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
}

class _IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    // release the memory allocated to variables when state object is removed.
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // run this method when the interface has been loaded
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // i think if we change timeStamp to _ it will work fine # delete
    //   // _nameController.text = addRecipe.userIngredients[widget.index];
    //   // i think to delete this line
    // });

    return TextFormField(
      // controller: _nameController,

      decoration: InputDecoration(hintText: 'Enter an ingredient'),
      // save text field data in friends list at index
      // whenever text field value changes
      onChanged: (value) => addRecipe.userIngredients[widget.index] = value,
      validator: (value) {
        if (value.trim().isEmpty) return 'Please enter an ingredient';
        return null;
      },
    );
  }
}
