import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/typedefs/search_term.dart';

//~Search Query Provider using a contain method.

final postBySearchTermProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, SearchTerm>((ref, SearchTerm searchQuery) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(
        FirebaseCollectionName.posts,
      )
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs
        .map(
          (post) => Post(
            postId: post.id,
            json: post.data(),
          ),
        )
        .where(
          (post) => post.message.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        );

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
