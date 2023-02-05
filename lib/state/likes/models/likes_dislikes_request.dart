import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

@immutable
class LikeDislikeRequest {
  final UserId likedBy;
  final PostId postId;

  const LikeDislikeRequest({
    required this.likedBy,
    required this.postId,
  });
}
