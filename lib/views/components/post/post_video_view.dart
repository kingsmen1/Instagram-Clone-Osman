import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/views/components/animations/errorAnimationView.dart';
import 'package:instagram_clone/views/components/animations/loadingAnimationView.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    //Controls a platform video player, and provides updates when the state is changing.
    final controller = VideoPlayerController.network(
      post.fileUrl,
    );
    final isVideoPlayerReady = useState(false);

    useEffect(() {
      controller.initialize().then((value) {
        isVideoPlayerReady.value = true;
        controller.setLooping(true);
        controller.play();
      });

      return controller.dispose; //this is a void function dont need to call it.
    }, [controller]);
    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(
            controller,
          ),
        );
      case false:
        return const LoadingAnimationView();
      default:
        //this shouldn't be called!
        return const ErrorAnimationView();
    }
  }
}
