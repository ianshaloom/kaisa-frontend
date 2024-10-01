// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataCacheModelAdapter extends TypeAdapter<DataCacheModel> {
  @override
  final int typeId = 0;

  @override
  DataCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataCacheModel(
      id: fields[0] as String,
      value: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      expiryDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DataCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
