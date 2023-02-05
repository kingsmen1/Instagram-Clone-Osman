import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/postSettings/models/post_settings.dart';
import 'package:instagram_clone/state/postSettings/notifiers/post_settings_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifer, Map<PostSettings, bool>>(
        (ref) => PostSettingNotifer());
