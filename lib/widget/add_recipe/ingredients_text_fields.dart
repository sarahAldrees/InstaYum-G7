import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index);

  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
}

class _IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController _ingredientController;

  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    // release the memory allocated to variables when state object is removed.
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  run this method when the interface has been loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _ingredientController.text = addRecipe.userIngredients[widget.index];
    });

    return TextFormField(
      controller: _ingredientController,
      decoration: InputDecoration(hintText: 'Enter an ingredient'),
      onChanged: (value) {
        addRecipe.userIngredients[widget.index] = value;
        addRecipe.formKey.currentState
            .validate(); //to validate every cange made by the user
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Please enter an ingredient';
        }
        return null;
      },
    );
  }
}
