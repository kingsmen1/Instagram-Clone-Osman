import 'package:instagram_clone/views/components/animations/lottie_animation_view.dart';
import 'package:instagram_clone/views/components/animations/models/lottie_animations.dart';

class SmallErrorAnimation extends LottieAnimationView {
  const SmallErrorAnimation({super.key})
      : super(
          animation: LottieAnimation.smallError,
        );
}
