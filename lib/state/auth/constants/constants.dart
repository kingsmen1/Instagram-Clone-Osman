import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const accountExistsWithDifferentCredentials =
      'account-exists-with-different-credentials';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
  //~private constructor we use it so no one can make and instance of this class
  const Constants._();
}
