import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../core/constants.dart';
import '../../core/error/cloud_storage_exceptions.dart';

class CloudStorageDs {
  final storage = FirebaseStorage.instance;

  Future<String> uploadImage(File compressedImage, String imei) async {
    try {
      final storageRef = storage.ref().child(receiptsFolder);

      final filename = '$imei.png';
      final imageRef = storageRef.child(filename);

      await imageRef.putFile(compressedImage);
      final downloadUrl = await imageRef.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
      throw CloudStorageExceptions(e.message ?? 'Error uploading image');
    }
  }
}

Future<XFile> compressImage(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 88,
    rotate: 180,
  );

  return result!;
}
