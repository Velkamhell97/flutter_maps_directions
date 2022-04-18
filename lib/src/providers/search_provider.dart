import 'package:flutter/material.dart';

/// Principalmente se necesita para modificar el texto de los inputs
class SearchProvider {
  final textControllerA = TextEditingController();
  final textControllerB = TextEditingController();

  void updateTextController(String text, String marker){
    if(marker == 'A'){
      textControllerA.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    } else {
      textControllerB.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    }
  }

  void clearTextController(String marker){
    if(marker == 'A'){
      textControllerA.clear();
    } else {
      textControllerB.clear();
    }
  }
}