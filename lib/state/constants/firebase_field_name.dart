import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const userId = 'uid';
  static const postId = 'post_id';
  static const comment = 'comment';
  static const createdAt = 'created_at';
  static const date = 'date';
  static const displayName = 'display_name';
  static const email = 'email';
  //~Private Constructor :we should use the private contractor when you need to create static variables or methods so no one can make instance of this class.
  const FirebaseFieldName._();
}
