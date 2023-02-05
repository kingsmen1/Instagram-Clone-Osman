import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/likes/models/likes_dislikes_request.dart';

final hasLikedPostProvider = StreamProvider.family
    .autoDispose<bool, LikeDislikeRequest>((ref, LikeDislikeRequest request) {
  final controller = StreamController<bool>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      controller.sink.add(false);
    } else {
      controller.sink.add(true);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
