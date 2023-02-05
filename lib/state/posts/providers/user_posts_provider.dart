//^revise

//~AutoDispose StreamProvider : this automatically dispose its stream when not in use
//^NOTE:StreamProvider always needs stream in return.
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/userId_provider.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/models/post_key.dart';

final userPostProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Post>>();
  //if someone listnening to stream we adding an empty list initially.
  controller.onListen = () {
    controller.sink.add([]);
  };

  //sorting post by their "createdAt" timestamp from newest to oldest.
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      //^NOTE:when using orderBy or any query method alway's use index
      //Steps for creating index -run the app checkout the error in console regarding
      //index follow the link to create index.
      //^revice 'where'
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .where(
        PostKey.userId,
        isEqualTo: userId,
      )
      .snapshots()
      .listen(
    (snapshot) {
      final documents = snapshot.docs;
      final posts = documents
          .where((doc) => !doc.metadata
              .hasPendingWrites) //hasPendingWrites is to ensure if theres no pending writes.
          .map((doc) => Post(
              postId: doc.id,
              json: doc
                  .data())); //doc.data Contains all the data of this document snapshot.
      controller.sink.add(posts);
    },
  );
  //~StreamProvider onDispose
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
