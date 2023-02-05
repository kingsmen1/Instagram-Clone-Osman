import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/enums/data_sorting.dart';
import 'package:instagram_clone/state/posts/typedefs/post_id.dart';

@immutable
class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    required this.postId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  @override
  bool operator ==(covariant RequestForPostAndComments other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            postId == other.postId &&
            sortByCreatedAt == other.sortByCreatedAt &&
            dateSorting == other.dateSorting &&
            limit == other.limit);
  }

  @override
  int get hashCode => Object.hash(postId, sortByCreatedAt, dateSorting, limit);
}