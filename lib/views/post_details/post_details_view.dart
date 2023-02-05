import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/enums/data_sorting.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/likes/models/likes_dislikes_request.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instagram_clone/state/posts/providers/delete_post_provider.dart';
import 'package:instagram_clone/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:instagram_clone/views/components/animations/smallErrroAnimation.dart';
import 'package:instagram_clone/views/components/comment/compact_comment_column.dart';
import 'package:instagram_clone/views/components/dialogs/alertDialog.dart';
import 'package:instagram_clone/views/components/dialogs/deleteDialog.dart';
import 'package:instagram_clone/views/components/like_button.dart';
import 'package:instagram_clone/views/components/like_count_view.dart';
import 'package:instagram_clone/views/components/post/postImageOrVideoView.dart';
import 'package:instagram_clone/views/components/post/post_date_view.dart';
import 'package:instagram_clone/views/components/post/post_display_name_message_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    //get the actual post together with comments
    final postWithComment = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    //can we delete this post?
    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(widget.post),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          postWithComment.when(
            data: (postWithComments) {
              return IconButton(
                  onPressed: () {
                    final url = postWithComments.post.fileUrl;
                    Share.share(
                      url,
                      subject: Strings.checkOutThisPost,
                    );
                  },
                  icon: const Icon(Icons.share));
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => const SmallErrorAnimation(),
          ),

          //*checking provider value without when method.
          //delete button or no delete button if user cannot delte this post.
          //this conditions says if canDeletePost is true we display IconButton.
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDelete = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context);
                if (shouldDelete ?? false) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: postWithComment.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVidoView(
                  post: postWithComments.post,
                ),
                Row(
                  children: [
                    if (postWithComments.post.allowLikes)
                      LikeButton(
                        request: LikeDislikeRequest(
                          likedBy: postWithComments.post.userId,
                          postId: postWithComments.post.postId,
                        ),
                      ),
                    if (postWithComments.post.allowComments)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PostCommentsView(
                                postId: postId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                  ],
                ),
                //post details (show divider at bottom)
                PostDisplayNameAndMessageView(
                  post: postWithComments.post,
                ),
                PostDateTimeView(
                  dateTime: postWithComments.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
                //compact comment's section
                CompactCommetCloumn(
                  comments: postWithComments.comments,
                ),
                //display likes of post if it allows
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(
                          postId: postId,
                        ),
                        //add spacing to bottom of screen
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
