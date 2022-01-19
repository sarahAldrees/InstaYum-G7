import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/widget/add_recipe/add_recipe_page.dart';
import 'package:instayum1/widget/add_recipe/speech_to_text_API.dart';

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index);

  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
}

class _IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController _ingredientController;
  String text = "";
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //  run this method when the interface has been loaded
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _ingredientController.text = addRecipe.userIngredients[widget.index];
    });

    return TextFormField(
      controller: _ingredientController,
      decoration: InputDecoration(
          //============================
          suffixIcon: AvatarGlow(
            animate: isListening,
            endRadius: 25,
            glowColor: Colors.orange,
            child: IconButton(
              onPressed: toggleRecording,
              icon: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Color(0xFFeb6d44),
              ),
            ),
          ),
          //---------------------
          hintText: 'Enter an ingredient'), //errorText: _errorText
      onChanged: (value) {
        addRecipe.userIngredients[widget.index] = value;
      },
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Please enter an ingredient';
        }
        return null;
      },
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) {
        setState(() => this.isListening = isListening);
      });
}
