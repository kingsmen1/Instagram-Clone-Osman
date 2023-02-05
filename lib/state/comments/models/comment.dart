// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/comments/typeDefs/comment_id.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId;
  final PostId onPostId;

  //from json
  Comment(
    Map<String, dynamic> json, {
    required this.id,
  })  : comment = json[FirebaseFieldName.comment],
        //converting TimeStamp to Date .
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFieldName.userId],
        onPostId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          other.comment == comment &&
          other.createdAt == createdAt &&
          other.fromUserId == fromUserId &&
          other.id == id &&
          other.onPostId == onPostId;

  @override
  int get hashCode => Object.hashAll(
        [
          runtimeType,
          comment,
          createdAt,
          fromUserId,
          id,
          onPostId,
        ],
      );
}
