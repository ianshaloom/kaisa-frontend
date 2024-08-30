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
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  static Future<List<KaisaUser>> fetchUsers() async {
    final snapShot = await users.get();
    final fetchedUsers = snapShot.docs
        .map((doc) => KaisaUser.fromQuerySnapshot(documentSnapshot: doc))
        .toList();

    return fetchedUsers;
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
    } catch (e) {
      throw GenericCloudException();
    }
  }

  // stream a single user by id
  static Stream singleUserStream({required String documentId}) {
    return users
        .doc(documentId)
        .snapshots()
        .map((event) => KaisaUser.fromDocSnapshot(documentSnapshot: event));
  }

  FirestoreUsersDs._sharedInstance();

  static final FirestoreUsersDs _shared = FirestoreUsersDs._sharedInstance();
  factory FirestoreUsersDs() => _shared;
}
