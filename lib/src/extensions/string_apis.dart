extension ColorParsing on String {
  bool equals(String text, [bool sensitive = false]){
    return sensitive ? this == text : toLowerCase() == text.toLowerCase();
  }
}