import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';

final postLikesCountProvider =
    StreamProvider.family.autoDispose<int, PostId>((ref, PostId postId) {
  final controller = StreamController<
      int>.broadcast(); //A controller where [stream] can be listened to more than once.

  //Initializing with zero if theres not likes on post.else it will create null issues.
  controller.onListen = () {
    controller.sink.add(0);
  };
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(
        FirebaseFieldName.postId,
        isEqualTo: postId,
      )
      .snapshots()
      .listen((snapshot) {
    controller.sink.add(snapshot.docs
        .length); //adding the number of "like" documents we find with this postId.
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
