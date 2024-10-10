import 'package:hive_flutter/hive_flutter.dart';

import '../hive-models/datacache/data_cache_model.dart';
import '../hive_init.dart';

class DataCacheCRUD {
  static final Box<DataCacheModel> _cacheBox = HiveBoxes.getDataCacheBox;

  // save user profile data
  static Future<void> cacheData(DataCacheModel data) async {
    // delete existing cache data of the id
    // but first check if the id exists
    final cachedDataa = _cacheBox.values.firstWhere(
      (element) => element.id == data.id,
      orElse: () => DataCacheModel(
        id: '',
        value: [],
        expiryDate: DateTime.now(),
      ),
    );

    if (cachedDataa.id.isNotEmpty) {
      await _cacheBox.delete(cachedDataa.key);
    }

    await _cacheBox.add(data);
  }

  // get user profile data
  static Future<DataCacheModel> getCachedData(String id) async {
    final userData = _cacheBox.values.firstWhere(
      (element) => element.id == id,
      orElse: () => DataCacheModel(
        id: '',
        value: [],
        expiryDate: DateTime.now(),
      ),
    );
    return userData;
  }

  // get all cached data
  static Future<List<DataCacheModel>> getAllCachedData() async {
    return _cacheBox.values.toList();
  }

  //  Clear all cached data
  static Future<void> clearCahe() async {
    await _cacheBox.clear();
  }
}
