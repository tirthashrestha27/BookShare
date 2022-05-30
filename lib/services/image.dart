import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ImageCapture extends ChangeNotifier {
  File imageFile;
  bool inProgress = false;
  ImageCapture({this.imageFile});
  Future<void> pickImage(ImageSource source) async {
    imageFile = await ImagePicker.pickImage(source: source);
    inProgress = true;
    notifyListeners();
    print(imageFile);
    print('$inProgress');
    if (imageFile != null) await cropImage();

    inProgress = false;
    notifyListeners();
  }

  Future<void> cropImage() async {
    print(imageFile.path);
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
    );
    print('$inProgress');
    imageFile = cropped ?? imageFile;
    print('$inProgress');

    notifyListeners();
  }

  void clear() {
    imageFile = null;
    notifyListeners();
  }
}
