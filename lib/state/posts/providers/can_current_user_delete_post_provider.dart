import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/userId_provider.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

//^NOTE:we can values directly into stream without StreamController
final canCurrentUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>((ref, Post post) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
});
