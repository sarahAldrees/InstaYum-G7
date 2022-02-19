//import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:instayum/widget/add_recipe/add_recipe_page.dart';
import 'package:instayum/widget/add_recipe/speech_to_text_API.dart';

class IngredientsTextFields extends StatefulWidget {
  final int index;
  IngredientsTextFields(this.index);

  @override
  IngredientsTextFieldsState createState() => IngredientsTextFieldsState();
}

class IngredientsTextFieldsState extends State<IngredientsTextFields> {
  TextEditingController? _ingredientController;
  String text = "";
  bool isListening = false;
  static bool isListening1 = false;
  // @required
  // Function(String text) onResult;
  // @required
  // ValueChanged<bool> onListening;
  // static final _speech = SpeechToText();
  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //  run this method when the interface has been loaded
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _ingredientController!.text =
          addRecipe.userIngredients[widget.index] ?? '';
    });

    return TextFormField(
      controller: _ingredientController,
      decoration: InputDecoration(
          //============================
          // suffixIcon: IconButton(
          //   onPressed: toggleRecording,
          //   icon: Icon(
          //     isListening1 ? Icons.mic : Icons.mic_none,
          //     color: Color(0xFFeb6d44),
          //   ),
          // ),
          //---------------------
          hintText: 'Enter an ingredient'), //errorText: _errorText
      onChanged: (value) {
        addRecipe.userIngredients[widget.index] = value;
      },
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Please enter an ingredient';
        }
        return null;
      },
    );
  }

  // void toggleRecording() async {
  //   if (!isListening1) {
  //     bool isAval = await _speech.initialize(
  //       onStatus: (status) => onListening(_speech.isListening),
  //       onError: (e) => print('Error: $e'),
  //     );

  //     if (isAval) {
  //       setState(() {
  //         isListening1 = true;
  //       });
  //       // it is for recognaization
  //       _speech.listen(
  //           onResult: (value) => setState(() {
  //                 this._ingredientController.text = value.recognizedWords;
  //                 onResult(value.recognizedWords);
  //               }));
  //     }
  //   } else {
  //     setState(() {
  //       isListening1 = false;
  //       _speech.stop();
  //     });
  //   }
  // }

  //____________________________________________________________________________
  //____________________________________________________________________________
  //____________________________________________________________________________

//The down code is old and will be deleted

  // Future toggleRecording() {
  //   if (this.mounted)
  //     setState(() {
  //       isListening1 = !isListening1;
  //     });
  //   SpeechApi.toggleRecording(
  //       onResult: (text) =>
  //           setState(() => this._ingredientController.text = text),
  //       onListening: (isListening) {
  //         setState(() => this.isListening = isListening);
  //       });
  // }
}
