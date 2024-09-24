import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/constants.dart';
import '../../core/error/cloud_storage_exceptions.dart';

class CloudStorageDs {
  final storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String imei) async {
    try {
      final storageRef = storage.ref().child(receiptsFolder);

      final imageRef = storageRef.child(imei);

      await imageRef.putFile(file);
      final downloadUrl = await imageRef.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw CloudStorageExceptions(e.message ?? 'Error uploading image');
    }
  }
}
