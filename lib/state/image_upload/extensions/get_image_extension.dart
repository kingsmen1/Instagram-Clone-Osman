import 'dart:async';

import 'package:flutter/material.dart' as material
    show Image, ImageConfiguration, ImageStreamListener;

//~Exntention for getting aspectRatio of an image

extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    //~completer hower for more information.
    final completer = Completer<double>();
    image.resolve(const material.ImageConfiguration()).addListener(
      material.ImageStreamListener(
        (imageInfo, synchronousCall) {
          final aspectRatio = imageInfo.image.height / imageInfo.image.width;
          imageInfo.image.dispose();
          completer.complete(aspectRatio);
        },
      ),
    );
    return completer.future;
  }
}
