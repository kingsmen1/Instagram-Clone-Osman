import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/state/image_upload/extensions/to_file.dart';

//~Picking image Image Picker helper
class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> get pickImageFromGallery =>
      _imagePicker.pickImage(source: ImageSource.gallery).toFile();

  static Future<File?> get pickVideoFromGallery =>
      _imagePicker.pickVideo(source: ImageSource.gallery).toFile();
}
