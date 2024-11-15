import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/constants/constants.dart';
import '../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../core/errors/app_exception.dart';
import '../../core/errors/cloud_storage_exceptions.dart';
import 'f_receipt.dart';
import 'f_receipt_errors.dart';

class FReceiptDs {
  final storage = FirebaseStorage.instance;
  final shop = FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  // create receipt
  Future<void> createReceipt(Map<String, dynamic> data) async {
    try {

       await kaisaBackendDS.postReceipt(data);

    } on PostDataException catch (e) {
      throw CouldNotCreateException(
          eMessage: e.details ?? 'Unable to post receipt');
    }
  }

  // get all receipts
  Future<List<ReceiptEntity>> fetchReceipts(String uuid) async {
    try {
      // reference to the shop
      final docRef = shop.doc(uuid).collection(receiptsSubCollection);

      final fetchedReceipts = await docRef.get();

      return fetchedReceipts.docs
          .map((doc) => ReceiptEntity.fromQuerySnapshot(documentSnapshot: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch receipts');
    }
  }

  // Fetch a single receipt
  Future<ReceiptEntity> fetchReceipt(String imei, String shopId) async {
    try {
      // reference to the shop
      final docRef = shop.doc(shopId).collection(receiptsSubCollection);

      final fetchedReceipt = await docRef.doc(imei).get();

      return ReceiptEntity.fromDocSnapshot(documentSnapshot: fetchedReceipt);
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch receipt');
    }
  }

  Future<String> uploadImage(File file, String imei) async {
    try {
      final storageRef = storage.ref().child('receipts');

      final imageRef = storageRef.child(imei);

      await imageRef.putFile(file);

      final downloadUrl = await imageRef.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw CloudStorageExceptions(e.message ?? 'Error uploading image');
    }
  }
}
