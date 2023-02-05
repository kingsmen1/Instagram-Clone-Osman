import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/posts/providers/post_by_search_term_provider.dart';
import 'package:instagram_clone/state/posts/typedefs/search_term.dart';
import 'package:instagram_clone/views/components/animations/dataNotFoundAnimation.dart';
import 'package:instagram_clone/views/components/animations/emptyContentWithTextAnimation.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:instagram_clone/views/components/post/post_sliver_grid_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTerm;
  const SearchGridView({
    super.key,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentWithText(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }
    final posts = ref.watch(
      postBySearchTermProvider(searchTerm),
    );

    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(child: DataNotFoundAnimation());
        } else {
          return PostSliverGridView(posts: posts);
        }
      },
      loading: () => const SliverToBoxAdapter(child: LoadingAnimationView()),
      error: (error, stackTrace) =>
          const SliverToBoxAdapter(child: ErrorAnimationView()),
    );
  }
}
