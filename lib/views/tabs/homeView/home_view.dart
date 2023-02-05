import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/posts/providers/all_post_provider.dart';
import 'package:instagram_clone/views/components/animations/emptyContentWithTextAnimation.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:instagram_clone/views/components/post/post_grid_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(allPostProvider.future),
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentWithText(
              text: Strings.noPostsAvailable,
            );
          } else {
            return PostGridView(
              posts: posts,
            );
          }
        },
        loading: () => const LoadingAnimationView(),
        error: (error, stackTrace) => const ErrorAnimationView(),
      ),
    );
  }
}
