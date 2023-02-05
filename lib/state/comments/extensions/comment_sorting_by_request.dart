import 'package:instagram_clone/enums/data_sorting.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';

//~Extension for sorting documents by createdAt property.
extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments =
          toList() //In order implement sort we must convert Iterable to List;
            ..sort((a, b) {
              //cascade operator: “..”is known as cascade notation(allow you to make a sequence of operations on the same object).
              switch (request.dateSorting) {
                case DateSorting.newestOnTop:
                  return b.createdAt.compareTo(a.createdAt);
                case DateSorting.oldestOnTop:
                  return a.createdAt.compareTo(b.createdAt);
              }
            });

      return sortedDocuments;
    } else {
      //if sortByCreatedAt is false we simply returning the list without sorting.
      return this;
    }
  }
}
