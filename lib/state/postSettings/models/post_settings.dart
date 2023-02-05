import 'package:instagram_clone/state/postSettings/constants/constants.dart';

enum PostSettings {
  allowLikes(
    title: Constants.allowLikesTitle,
    description: Constants.allowLikesDescription,
    storageKey: Constants.allowLikesStorageKey,
  ),

  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDescription,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title, description, storageKey;
  const PostSettings({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
