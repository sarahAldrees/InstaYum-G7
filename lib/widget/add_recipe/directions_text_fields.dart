import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';
import 'package:instayum1/widget/add_recipe/speech_to_text_API.dart';

class DirectionsTextFields extends StatefulWidget {
  final int index;
  DirectionsTextFields(this.index);

  @override
  _DirectionsTextFieldsState createState() => _DirectionsTextFieldsState();
}

class _DirectionsTextFieldsState extends State<DirectionsTextFields> {
  TextEditingController _directionController;
  String text = "";
  bool isListening = false;
  bool isListening1 = false;
  @override
  void initState() {
    super.initState();
    _directionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // run this method when the interface has been loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _directionController.text = addRecipe.userDirections[widget.index];
    });

    return TextFormField(
      controller: _directionController,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: toggleRecording,
            icon: Icon(
              isListening1 ? Icons.mic : Icons.mic_none,
              color: Color(0xFFeb6d44),
            ),
          ),
          hintText: 'Enter a direction'), // errorText: _errorText
      onChanged: (value) {
        addRecipe.userDirections[widget.index] = value;
        // setState(() {}); //used to refresh the screen
      },
      validator: (value) {
        if (value.trim().isEmpty) return 'Please enter a direction';

        return null;
      },
    );
  }

  Future toggleRecording() {
    if (this.mounted)
      setState(() {
        isListening1 = !isListening1;
      });
    SpeechApi.toggleRecording(
        onResult: (text) =>
            setState(() => this._directionController.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
        });
  }
}
