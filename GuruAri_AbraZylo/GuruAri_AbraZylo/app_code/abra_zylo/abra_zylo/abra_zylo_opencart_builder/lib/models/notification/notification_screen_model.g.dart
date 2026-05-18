// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_screen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationScreenModelAdapter
    extends TypeAdapter<NotificationScreenModel> {
  @override
  final int typeId = 41;

  @override
  NotificationScreenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationScreenModel(
      notifications: (fields[1] as List?)?.cast<Notifications>(),
      error: fields[2] as int?,
    )..eTag = fields[100] as String?;
  }

  @override
  void write(BinaryWriter writer, NotificationScreenModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.notifications)
      ..writeByte(2)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationScreenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationsAdapter extends TypeAdapter<Notifications> {
  @override
  final int typeId = 42;

  @override
  Notifications read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notifications(
      notificationId: fields[1] as String?,
      title: fields[2] as String?,
      image: fields[3] as String?,
      dominantColor: fields[4] as String?,
      type: fields[5] as String?,
      id: fields[6] as String?,
      content: fields[7] as String?,
      subTitle: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Notifications obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.notificationId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.dominantColor)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.subTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationScreenModel _$NotificationScreenModelFromJson(
        Map<String, dynamic> json) =>
    NotificationScreenModel(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => Notifications.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as int?,
    )..eTag = json['etag'] as String?;

Map<String, dynamic> _$NotificationScreenModelToJson(
        NotificationScreenModel instance) =>
    <String, dynamic>{
      'etag': instance.eTag,
      'notifications': instance.notifications,
      'error': instance.error,
    };

Notifications _$NotificationsFromJson(Map<String, dynamic> json) =>
    Notifications(
      notificationId: json['notification_id'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominant_color'] as String?,
      type: json['type'] as String?,
      id: json['id'] as String?,
      content: json['content'] as String?,
      subTitle: json['subTitle'] as String?,
    );

Map<String, dynamic> _$NotificationsToJson(Notifications instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'title': instance.title,
      'image': instance.image,
      'dominant_color': instance.dominantColor,
      'type': instance.type,
      'id': instance.id,
      'content': instance.content,
      'subTitle': instance.subTitle,
    };
