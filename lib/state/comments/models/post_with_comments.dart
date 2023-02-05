import 'package:collection/equality.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

@immutable
class PostWithComment {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithComment({
    required this.post,
    required this.comments,
  });

//~equality
  @override
  bool operator ==(covariant PostWithComment other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          post == other.post &&
          const IterableEquality().equals(
            //IterableEquality:used for checking equality it throws bool even if the order of iterables is different.
            comments,
            other.comments,
          );

  @override
  int get hashCode => Object.hash(
        post,
        comments,
      );
}
