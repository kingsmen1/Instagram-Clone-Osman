import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/postSettings/models/post_settings.dart';
import 'package:instagram_clone/state/posts/models/post_key.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final double aspectRatio;
  final String thumnailStorageId;
  final String originalFileStorageId;
  final Map<PostSettings, bool> postSettings;

  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        //we are checking if the enum value is present in json if not we assigning "FileType.image"
        //the result of fileType.name ("FileType.image" or "FileType.video") is the string "image" or can be "video".
        fileType = FileType.values.firstWhere(
          (fileType) => fileType.name == json[PostKey.fileType],
          orElse: () => FileType.image,
        ),
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        thumnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        //!Test
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSettings.values
                    .firstWhere((element) => element.storageKey == entry.key):
                entry.value,
        };

  bool get allowLikes => postSettings[PostSettings.allowLikes] ?? false;
  bool get allowComments => postSettings[PostSettings.allowComments] ?? false;
}
