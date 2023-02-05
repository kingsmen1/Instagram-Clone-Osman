import 'dart:io';
import 'package:flutter/material.dart' show immutable;
import 'package:instagram_clone/state/image_upload/models/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;

  const ThumbnailRequest({
    required this.file,
    required this.fileType,
  });

  //~Equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileType == other.fileType;

  @override
  int get hashCode => Object.hashAll([
        //~runtimeType: The runtimeType property helps to find what kind of data is stored in the variable
        runtimeType,
        file,
        fileType,
      ]);
}
