import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/posts/providers/user_posts_provider.dart';
import 'package:instagram_clone/views/components/animations/emptyContentWithTextAnimation.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:instagram_clone/views/components/post/post_grid_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //~Async working with async value
    final post = ref.watch(userPostProvider);
    //~RefreshIndicat
    return RefreshIndicator(
      onRefresh: () {
        //Forces a provider to re-evaluate its state immediately, and return the created value.
        ref.refresh(userPostProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: post.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const EmptyContentWithText(text: Strings.youHaveNoPosts);
            } else {
              return PostGridView(
                posts: posts,
              );
            }
          },
          error: (error, stackTrace) => const ErrorAnimationView(),
          loading: () => const LoadingAnimationView()),
    );
  }
}
