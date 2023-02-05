import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/postSettings/models/post_settings.dart';

class PostSettingNotifer extends StateNotifier<Map<PostSettings, bool>> {
  PostSettingNotifer()
      : super(
          //Setting allow likes and comment's to true by default
          UnmodifiableMapView({
            for (final setting in PostSettings.values) setting: true,
          }),
        );

  void setSettings(
    PostSettings setting,
    bool value,
  ) {
    //checking if the receaved setting is correct & if the value is same.
    final existingSetting = state[setting];
    if (existingSetting == null || existingSetting == value) {
      return;
    }
    //if setting is new to our state's previous setting we add it to states unmodifiable map by selecting that key.
    state = Map.unmodifiable(
      Map.from(state)
        ..[setting] =
            value, //getting previous key from our state and setting it with new value.ex:'allowLikes':true(new value)
    );
  }
}
