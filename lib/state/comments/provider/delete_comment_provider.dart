import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/notifiers/deleteCommentNotifier.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentNotifier, IsLoading>(
        (_) => DeleteCommentNotifier());
