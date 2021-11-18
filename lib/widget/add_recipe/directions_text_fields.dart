import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';

class DirectionsTextFields extends StatefulWidget {
  final int index;
  DirectionsTextFields(this.index);

  @override
  _DirectionsTextFieldsState createState() => _DirectionsTextFieldsState();
}

class _DirectionsTextFieldsState extends State<DirectionsTextFields> {
  TextEditingController _directionController;

  @override
  void initState() {
    super.initState();
    _directionController = TextEditingController();
  }

  @override
  void dispose() {
    // release the memory allocated to variables when state object is removed.
    _directionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // run this method when the interface has been loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _directionController.text = addRecipe.userDirections[widget.index];
    });

    return TextFormField(
      controller: _directionController,
      decoration: InputDecoration(hintText: 'Enter a direction'),
      onChanged: (value) {
        addRecipe.userDirections[widget.index] = value;
        addRecipe.formKey.currentState
            .validate(); //to validate every cange made by the user
      },
      validator: (value) {
        if (value.trim().isEmpty) return 'Please enter a direction';
        return null;
      },
    );
  }
}
