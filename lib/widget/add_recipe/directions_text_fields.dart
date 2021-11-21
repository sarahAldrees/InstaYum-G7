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

  String get _errorText {
    //this method will show error message on every change made by the user using errorText
    final text = _directionController.value.text;
    if (text.isEmpty) {
      return 'Please enter a direction';
    }
    // return null if the text is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // run this method when the interface has been loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _directionController.text = addRecipe.userDirections[widget.index];
    });

    return TextFormField(
      controller: _directionController,
      decoration:
          InputDecoration(hintText: 'Enter a direction', errorText: _errorText),
      onChanged: (value) {
        addRecipe.userDirections[widget.index] = value;
        setState(() {}); //used to refresh the screen
      },
      validator: (value) {
        if (value.trim().isEmpty) return 'Please enter a direction';

        return null;
      },
    );
  }
}
