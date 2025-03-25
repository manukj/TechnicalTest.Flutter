// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflinePostModelAdapter extends TypeAdapter<OfflinePostModel> {
  @override
  final int typeId = 0;

  @override
  OfflinePostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflinePostModel(
      id: fields[0] as int,
      title: fields[1] as String,
      body: fields[2] as String,
      userId: fields[3] as int,
      savedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OfflinePostModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflinePostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
