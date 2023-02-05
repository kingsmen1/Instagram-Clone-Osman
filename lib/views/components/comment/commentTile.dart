import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/userId_provider.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/provider/delete_comment_provider.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone/views/components/animations/smallErrroAnimation.dart';
import 'package:instagram_clone/views/components/constants/string.dart';
import 'package:instagram_clone/views/components/dialogs/alertDialog.dart';
import 'package:instagram_clone/views/components/dialogs/deleteDialog.dart';
import 'package:instagram_clone/views/components/dialogs/deleteDialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(comment.fromUserId));
    return userInfo.when(
      data: (userInfoModel) {
        final currentUserId = ref.read(userIdProvider);
        return ListTile(
          title: Text(userInfoModel.displayName),
          subtitle: Text(comment.comment),
          trailing: comment.fromUserId == currentUserId
              ? IconButton(
                  onPressed: () async {
                    final bool shouldDeleteComment =
                        await displayDeleteDialog(context);
                    if (shouldDeleteComment) {
                      await ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                  icon: const Icon(Icons.delete))
              : null,
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) => const SmallErrorAnimation(),
    );
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment)
          .present(context)
          .then((value) => value ?? false);
}
