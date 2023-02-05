import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/constants/firebase_field_name.dart';
import 'package:instagram_clone/state/image_upload/extensions/getCollectionNameFromFileType.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';

typedef Suceeded = bool;

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);
  set isLoading(value) => state = value;

  Future<bool> deletePost({required Post post}) async {
    isLoading = true;

    try {
      //delete post thumbnail
      //Creating FirebaseStorage reference
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumnailStorageId)
          .delete();

      //delete the post orignal file(image or video)
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      //delete all comments associated with the post
      await _deleteAllDocument(
        postId: post.postId,
        inCollection: FirebaseCollectionName.comments,
      );

      //delete all likes associated with the post
      _deleteAllDocument(
        postId: post.postId,
        inCollection: FirebaseCollectionName.likes,
      );

      //finally delete the post itself.
      final postSnapshot = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(
            FieldPath.documentId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();

      // for (final doc in postSnapshot.docs) {
      //   await doc.reference.delete();
      // }
      await postSnapshot.docs.first.reference.delete();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocument({
    required PostId postId,
    required String inCollection,
  }) async {
    //~FirebaseFirestore:a transaction is a set of read and write operations on one or more documents.
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(FirebaseFieldName.postId, isEqualTo: postId)
            .get();
        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
