import 'package:flutter/cupertino.dart';

//~Extension for Dismissing Keyboard.
extension DismissKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
