import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/likes/models/likes_dislikes_request.dart';
import 'package:instagram_clone/state/likes/models/likes_payload.dart';

final likesDislikesPostProvider = FutureProvider.family
    .autoDispose<bool, LikeDislikeRequest>(
        (ref, LikeDislikeRequest request) async {
  final query = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
      .get();

  //first see if the user has liked the same post or not.
  final hasLiked =
      await query.then((value) => value.docs.isNotEmpty); //true if liked.
  if (hasLiked) {
    try {
      //!test
      await query.then((snapshot) => snapshot.docs.first.reference.delete());
      //alternative for deleting.
      /* await query.then((snapshot) async {
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }); */
      return true;
    } catch (_) {
      return false;
    }
  } else {
    //post a like object.
    final like = LikesPayload(
      postId: request.postId,
      userId: request.likedBy,
      date: DateTime.now(),
    );

    try {
      FirebaseFirestore.instance
          .collection(FirebaseCollectionName.likes)
          .add(like);
      return true;
    } catch (_) {
      return false;
    }
  }
});
