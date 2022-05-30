import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorageService {
  StorageUploadTask _uploadTask;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://bookchain-a8ed1.appspot.com');
  Future<String> upload({File image, String name}) async {
    String filePath = 'books/$name.jpg';
    _uploadTask = _storage.ref().child(filePath).putFile(image);
    var downloadURL = await (await _uploadTask.onComplete).ref.getDownloadURL();
    return downloadURL.toString();
  }

  Future<String> uploadUser({File image, String name}) async {
    String filePath = 'users/$name.jpg';
    _uploadTask = _storage.ref().child(filePath).putFile(image);
    var downloadURL = await (await _uploadTask.onComplete).ref.getDownloadURL();
    return downloadURL.toString();
  }

  void deletePhoto(String url) async {
    StorageReference a = await _storage.getReferenceFromUrl(url);

    a.delete();
  }
}
