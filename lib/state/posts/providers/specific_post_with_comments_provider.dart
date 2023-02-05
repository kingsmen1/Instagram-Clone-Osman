import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/comments/models/post_with_comments.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComment, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<PostWithComment>();

  Post? post;
  Iterable<Comment>? comments;

  void notify() {
    final localPost = post;
    if (localPost == null) {
      return;
    }
    final outputComments = (comments ?? []).applySortingFrom(request);

    final result = PostWithComment(
      post: localPost,
      comments: outputComments,
    );
    controller.sink.add(result);
  }

  final postSub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .where(
        FieldPath.documentId,
        isEqualTo: request.postId,
      )
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      post = null;
      comments = null;
      notify();
      return;
    }
    final doc = snapshot.docs.first;
    //checking for pending writes like serverTimeStamp.
    if (doc.metadata.hasPendingWrites) {
      return;
    }
    post = Post(postId: doc.id, json: doc.data());
    notify();
  });

  final commentsQuery = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      );

  final limittedCommentsQuery = request.limit != null
      ? commentsQuery.limit(request.limit!)
      : commentsQuery;

  final commentsSub = limittedCommentsQuery.snapshots().listen((snapshot) {
    comments = snapshot.docs
        .where(
          (snap) => !snap.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Comment(
            doc.data(),
            id: doc.id,
          ),
        )
        .toList();
    notify();
  });

  ref.onDispose(() {
    commentsSub.cancel();
    postSub.cancel();
    controller.close();
  });

  return controller.stream;
});
