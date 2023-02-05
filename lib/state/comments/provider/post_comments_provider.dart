import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
        (ref, RequestForPostAndComments request) {
  //we return empty array if no comments.
  final controller = StreamController<Iterable<Comment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .snapshots()
      .listen((snapshot) {
    final docs = snapshot.docs;
    final limitedDocs = request.limit != null
        ? docs.take(request.limit!)
        : docs; //take : limiting document's by the number of given request.
    final Iterable<Comment> comments = limitedDocs
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (document) => Comment(document.data(), id: document.id),
        );
    final sortedComments = comments.applySortingFrom(request);
    controller.sink.add(sortedComments);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  //we return empty array if no comments.
  return controller.stream;
});
