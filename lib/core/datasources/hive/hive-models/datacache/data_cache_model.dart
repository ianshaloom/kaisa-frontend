import 'package:hive_flutter/hive_flutter.dart';

part 'data_cache_model.g.dart';

@HiveType(typeId: 0)
class DataCacheModel extends HiveObject {
  DataCacheModel({
    required this.id,
    required this.value,
    required this.expiryDate,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  List<Map<String, dynamic>> value;
  @HiveField(2)
  DateTime expiryDate;
}