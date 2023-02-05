import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/typeDefs/comment_id.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentNotifier extends StateNotifier<IsLoading> {
  DeleteCommentNotifier() : super(false);

  set isLoading(IsLoading isLoading) => state = isLoading;

  Future<bool> deleteComment({required CommentId commentId}) async {
    try {
      isLoading = true;
      //~Firebase querying
      //querying the comment
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(FieldPath.documentId,
              isEqualTo: commentId) //FieldPath.documentId : Getting doc Id.
          .limit(1)
          .get();

      //executing query then iterating on every doc as its a Map then deleting it.
      await query.then(
        (query) async {
          for (final doc in query.docs) {
            await doc.reference
                .delete(); //deleting the doc by its reference(Returns the reference of this snapshot).
          }
        },
      );
      //await query.docs.first.reference.delete();//smilar syntax if query is executed first.

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
