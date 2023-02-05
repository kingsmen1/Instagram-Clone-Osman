import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_image_extension.dart';

//~Extention for getting AspectRatio of image which is in Uint8List format(image which is basically fetched from firebase)
extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() async {
    final Image image = Image.memory(this);
    return image.getAspectRatio();
  }
}
