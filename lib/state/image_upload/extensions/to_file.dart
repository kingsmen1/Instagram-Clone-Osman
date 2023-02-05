import 'dart:io';

import 'package:image_picker/image_picker.dart';

//~Extension for converting a Future<XFile> to Future<File>
extension ToFile on Future<XFile?> {
  //XFile is a format from image_picker package.
  Future<File?> toFile() =>
      then((xFile) => //then:is a callbacks to be called when this future completes.
              xFile?.path) //then is comming from this.then as its a future
          .then(
        (filePath) => filePath != null ? File(filePath) : null,
      );
}


//^NOTE: image_picker package gives us a picked file in XFile format so that is why we created this convert extension.