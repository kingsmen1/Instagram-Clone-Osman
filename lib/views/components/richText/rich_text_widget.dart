import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/views/components/richText/base_text.dart';
import 'package:instagram_clone/views/components/richText/link_text.dart';

class RichTextWidget extends StatelessWidget {
  final TextStyle? styleForAll;
  final Iterable<BaseText> texts;
  const RichTextWidget({
    super.key,
    this.styleForAll,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          children: texts.map(
        (baseText) {
          if (baseText is LinkText) {
            return TextSpan(
              text: baseText.text,
              //Textstyle merging .
              style: styleForAll?.merge(baseText.style),
              //recognizer:A gesture recognizer that will receive events that hit this span.
              recognizer: TapGestureRecognizer()..onTap = baseText.onTap,
            );
          } else {
            return TextSpan(
                text: baseText.text, style: styleForAll?.merge(baseText.style));
          }
        },
      ).toList()),
    );
  }
}
