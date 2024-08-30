// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_user_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataHiveAdapter extends TypeAdapter<UserDataHive> {
  @override
  final int typeId = 1;

  @override
  UserDataHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataHive(
      uuid: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      address: fields[3] as String,
      isEmailVerified: fields[4] as bool,
      role: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.isEmailVerified)
      ..writeByte(5)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
