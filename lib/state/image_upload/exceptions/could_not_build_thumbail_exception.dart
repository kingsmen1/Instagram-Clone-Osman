//~Custom Exception.

import 'package:flutter/foundation.dart' show immutable;

//^revise
@immutable
class CouldNotBuildThumbnailException implements Exception {
  final message = 'Could not build thumbnail';
  const CouldNotBuildThumbnailException();
}

//^NOTE: we are implementing Abstract Exception class and automatically callling its super with our custom message