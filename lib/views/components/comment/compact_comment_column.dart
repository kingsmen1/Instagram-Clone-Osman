import 'package:flutter/material.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/views/components/comment/compact_comment_tile.dart';

class CompactCommetCloumn extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommetCloumn({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments
              .map(
                (comment) => CompactCommentTile(
                  comment: comment,
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
