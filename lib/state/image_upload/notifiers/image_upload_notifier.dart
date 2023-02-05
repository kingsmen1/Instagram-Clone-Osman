import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone/state/image_upload/constants/constants.dart';
import 'package:instagram_clone/state/image_upload/exceptions/could_not_build_thumbail_exception.dart';
import 'package:instagram_clone/state/image_upload/extensions/getCollectionNameFromFileType.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone/state/postSettings/models/post_settings.dart';
import 'package:instagram_clone/state/posts/models/post_key.dart';
import 'package:instagram_clone/state/posts/models/post_payload.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  //^revise storing image.
  //*Function responsible for uploading images and videos to backend.
  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSettings, bool> postSettings,
    required UserId userId,
  }) async {
    //using setter / equavalent to state = true;
    isLoading = true;
    late Uint8List thumbnailUint8List;
    switch (fileType) {
      case FileType.image:
        //converting file to bytes & then converting it to Image
        final fileAsImage = img.decodeImage(
            file //decodeImage:Decode the given image file bytes by first identifying the format of the file and using that decoder to decode the file into a single frame [Image].
                .readAsBytesSync()); //readAsBytesSync:Synchronously reads the entire file contents as a list of bytes.
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        //create thumbnail
        final thumbnail =
            img.copyResize(fileAsImage, width: Constants.imageThumbnailWidth);
        final thumbnailData = img.encodeJpg(thumbnail);
        //converting it to Uint8List format
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumbnailQuality,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUint8List = thumb;
        }
        break;
    }
    //calculate aspect ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    //calculate references
    final fileName = const Uuid().v4();

    //~Creating FirebaseStorage reference.
    //create reference to the thumbnail and the image itself.
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //uploading thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      //getting storage id
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //uploading the original file.
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      //upload post itself
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}

//^NOTE: WORKING OF "upload" function
//1) checking the file type if its a video of image.

//2) if image                                                                                                           - reading entire file contents as a list of bytes & decode that bytes into an Image format using "img.decodeImage".     - if image null call custom Exeption which will automatically terminates our whole function so we dont need to return false                                                                                                                   - create a thumbnail using image package                                                                                - again converting it to UintList,                                                                                      - assigning it to variable                                                                                              

//3) if video - creating thumbnail with "VideoThumbnail" package - if not null assigning to variable 

//4) calculate aspect ratio

