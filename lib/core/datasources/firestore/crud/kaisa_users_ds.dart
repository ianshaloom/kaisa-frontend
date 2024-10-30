import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../constants/constants.dart';
import '../models/kaisa-user/kaisa_user.dart';

class FirestoreUsersDs {
  static final users = FirebaseFirestore.instance.collection(usersCollection);
  static final shops =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);

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

  //  stream of a single user by id fromdocsnapshot
  static Stream<KaisaUser> userStream({required String userId}) {
    return users.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return KaisaUser.fromJson(doc.data()!);
      } else {
        return KaisaUser.empty;
      }
    });
  }

  // fetch all shops, shops are a list of strings
  static Future<List<String>> fetchShops() async {
    try {
      List<String> shopsList = [];

      final fetchedShops = await shops.get();

      for (var doc in fetchedShops.docs) {
        final shop = doc.data();
        shopsList.add(shop['shopName'] as String);
      }

      return shopsList;
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'No Error message');
    }
  }

  FirestoreUsersDs._sharedInstance();
  static final FirestoreUsersDs _shared = FirestoreUsersDs._sharedInstance();
  factory FirestoreUsersDs() => _shared;
}
