import 'package:instagram_clone/views/components/animations/lottie_animation_view.dart';
import 'package:instagram_clone/views/components/animations/models/lottie_animations.dart';

class DataNotFoundAnimation extends LottieAnimationView {
  const DataNotFoundAnimation({super.key})
      : super(
          animation: LottieAnimation.dataNotFound,
        );
}
