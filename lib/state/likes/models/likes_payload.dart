import 'dart:collection';

import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

class LikesPayload extends MapView<String, String> {
  LikesPayload({
    required PostId postId,
    required UserId userId,
    required DateTime date,
  }) : super({
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.date: date.toIso8601String(),
        });
}
