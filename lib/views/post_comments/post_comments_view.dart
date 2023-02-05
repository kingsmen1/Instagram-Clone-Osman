import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/userId_provider.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/comments/provider/post_comments_provider.dart';
import 'package:instagram_clone/state/comments/provider/send_comment_provider.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone/views/components/animations/emptyContentWithTextAnimation.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:instagram_clone/views/components/comment/commentTile.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/extensions/dismiss_keyboard.dart';

//~HookConsumerWidget : Its a stateless widget opposite to statefull StatefulHookConsumerWidget

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentsView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();

    final hasText = useState(false);
    //~useState:Creates a variable and subscribes to it. whenever it updates this rebuilds.
    final request = useState(RequestForPostAndComments(
      postId: postId,
    ));

    final comments = ref.watch(postCommentProvider(request.value));

    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [
      commentController
    ] //hooking a commentController whenever this updates/changes this useEffect fuction get called.
        );
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.comments),
          actions: [
            IconButton(
              onPressed: hasText.value
                  ? () {
                      _submitCommentWithController(commentController, ref);
                    }
                  : null, //enabeling only if commentController has text .
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: SafeArea(
          //^special widget
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                  flex: 4,
                  child: comments.when(
                    data: (comments) {
                      if (comments.isEmpty) {
                        return const SingleChildScrollView(
                          child:
                              EmptyContentWithText(text: Strings.noCommentsYet),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () {
                          ref.refresh(
                            postCommentProvider(request.value),
                          );
                          return Future.delayed(
                            const Duration(
                              milliseconds: 1000,
                            ),
                          );
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments.elementAt(index);
                              return CommentTile(
                                comment: comment,
                              );
                            }),
                      );
                    },
                    loading: () => const LoadingAnimationView(),
                    error: (error, stackTrace) => const ErrorAnimationView(),
                  )),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      textInputAction: TextInputAction.send,
                      controller: commentController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _submitCommentWithController(
                            commentController,
                            ref,
                          );
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(Strings.writeYourCommentHere),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

        //  comments.when(
        //   data: (commentsData) {
        //     if (commentsData.isEmpty) {
        //       return const EmptyContentWithText(text: Strings.noCommentsYet);
        //     }else{

        //     }
        //   },
        //   loading: () => const LoadingAnimationView(),
        //   error: (error, stackTrace) => const ErrorAnimationView(),
        // ),
        );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      //*dismissing Keyboard using extension.
      dismissKeyboard();
    }
  }
}
