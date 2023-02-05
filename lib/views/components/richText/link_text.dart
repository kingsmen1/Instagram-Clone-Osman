import 'package:flutter/animation.dart';
import 'package:instagram_clone/views/components/richText/base_text.dart';

class LinkText extends BaseText {
  final VoidCallback onTap;
  const LinkText({
    required super.text,
    required this.onTap,
    super.style,
  });
}
