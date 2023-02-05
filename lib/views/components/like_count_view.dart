import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/likes/provider/post_likes_count_provider.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone/views/components/animations/smallErrroAnimation.dart';
import 'package:instagram_clone/views/components/constants/string.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(postLikesCountProvider(postId));
    return likes.when(
      data: (int likesCount) {
        final personOrPeople =
            likesCount == 1 ? Strings.person : Strings.people;
        return Text('$likesCount $personOrPeople ${Strings.likedThis}');
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: ((error, stackTrace) => const SmallErrorAnimation()),
    );
  }
}
