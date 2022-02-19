// import 'package:flutter/cupertino.dart';
// import 'package:instayum/widget/add_recipe/ingredients_text_Fields.dart';

// class SpeechApi {
//   static final _speech = SpeechToText();

//   static Future<bool> toggleRecording({
//     @required Function(String text) onResult,
//     @required ValueChanged<bool> onListening,
//   }) async {
//     if (_speech.isListening) {
//       _speech.stop();
//       return true;
//     }

//     final isAvailable = await _speech.initialize(
//       onStatus: (status) => onListening(_speech.isListening),
//       onError: (e) => print('Error: $e'),
//     );

//     if (isAvailable) {
//       // it is for recognaization
//       _speech.listen(onResult: (value) => onResult(value.recognizedWords));
//     }

//     return isAvailable;
//   }
// }
