//~Extention to convert 0x????? or #?????? to color
import 'package:flutter/material.dart';
import 'package:instagram_clone/extension/string/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
          //padLeft used for adding characters to start of string untill its given length
          //condition is met.
          int.parse(
        removeAll(['0x', '#']).padLeft(8, 'ff'),
        //we converting a Hex string into int using radix:
        //var n_16 = int.parse('FF', radix: 16);
        //The output of the code = 255
        radix: 16,
      ));
}
