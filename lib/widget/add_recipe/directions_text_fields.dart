import 'package:flutter/material.dart';
import 'package:instayum/widget/add_recipe/add_recipe_page.dart';

import 'package:speech_to_text/speech_to_text.dart';

class DirectionsTextFields extends StatefulWidget {
  final int index;
  DirectionsTextFields(this.index);

  @override
  _DirectionsTextFieldsState createState() => _DirectionsTextFieldsState();
}

class _DirectionsTextFieldsState extends State<DirectionsTextFields> {
  TextEditingController? _directionController;
  String text = "";
  bool isListening = false;
  bool isListening1 = false;
  @required
  Function(String text)? onResult;
  @required
  ValueChanged<bool>? onListening;
  static final _speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _directionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // run this method when the interface has been loaded
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _directionController!.text = addRecipe.userDirections[widget.index] ?? '';
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
          hintText: 'Enter a direction'),
      onChanged: (value) {
        addRecipe.userDirections[widget.index] = _directionController!.text;
      },
      validator: (value) {
        if (value!.trim().isEmpty) return 'Please enter a direction';

        return null;
      },
    );
  }

  void toggleRecording() async {
    if (!isListening1) {
      bool isAval = await _speech.initialize(
        onStatus: (status) => onListening!(_speech.isListening),
        onError: (e) => print('Error: $e'),
      );

      if (isAval) {
        setState(() {
          isListening1 = true;
        });
        // it is for recognaization
        _speech.listen(
            onResult: (value) => setState(() {
                  _directionController!.text = value.recognizedWords;
                  addRecipe.userDirections[widget.index] =
                      value.recognizedWords;
                }));
      }
    } else {
      setState(() {
        isListening1 = false;
        _speech.stop();
      });
    }
  }
}
