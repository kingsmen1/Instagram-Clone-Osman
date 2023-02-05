import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/likes/models/likes_dislikes_request.dart';
import 'package:instagram_clone/state/likes/provider/has_liked_post_provider.dart';
import 'package:instagram_clone/state/likes/provider/like_dislike_post_provider.dart';
import 'package:instagram_clone/views/components/animations/smallErrroAnimation.dart';

class LikeButton extends ConsumerWidget {
  final LikeDislikeRequest request;
  const LikeButton({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(hasLikedPostProvider(request));
    return isLiked.when(
      data: (bool isLiked) {
        return IconButton(
          icon: FaIcon(
            isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          ),
          onPressed: () {
            ref.read(likesDislikesPostProvider(request));
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const SmallErrorAnimation(),
    );
  }
}
