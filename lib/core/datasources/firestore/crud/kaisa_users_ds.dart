import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/errors/cloud_storage_exceptions.dart';
import '../models/kaisa-user/kaisa_user.dart';

class FirestoreUsersDs {
  static final users = FirebaseFirestore.instance.collection('kaisa-users');

  static Future<void> createUser({
    required KaisaUser user,
  }) async {
    final docId = user.uuid;
    final document = user.toJson();

    try {
      await users.doc(docId).set(document);
    } on FirebaseException catch (e) {
      throw CouldNotCreateException(eMessage: e.message ?? 'No Error message');
    }
  }

  static Future<List<KaisaUser>> fetchUsers() async {
    try {
      final fetchedUsers = await users.get();

      return fetchedUsers.docs
          .map((doc) => KaisaUser.fromQuerySnapshot(documentSnapshot: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'No Error message');
    }
  }

  // get a future of a single user by id fromdocsnapshot
  static Future<KaisaUser> fetchUser({required String userId}) async {
    try {
      final fetchedUser = await users.doc(userId).get();

      if (fetchedUser.exists) {
        return KaisaUser.fromJson(fetchedUser.data()!);
      } else {
        return KaisaUser.empty;
      }
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'No Error message');
    }
  }

  FirestoreUsersDs._sharedInstance();
  static final FirestoreUsersDs _shared = FirestoreUsersDs._sharedInstance();
  factory FirestoreUsersDs() => _shared;
}
