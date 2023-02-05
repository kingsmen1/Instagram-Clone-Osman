import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/comments/provider/delete_comment_provider.dart';
import 'package:instagram_clone/state/comments/provider/send_comment_provider.dart';
import 'package:instagram_clone/state/image_upload/providers/image_upload_provider.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone/state/posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final IsLoading isUploadingImage = ref.watch(imageUploadProvider);
  final IsLoading isCommentDeleting = ref.watch(deleteCommentProvider);
  final IsLoading isCommentSending = ref.watch(sendCommentProvider);
  final IsLoading isDeletingPost = ref.watch(deletePostProvider);
  return authState.isLoading ||
      isUploadingImage ||
      isCommentDeleting ||
      isCommentSending ||
      isDeletingPost;
});
