// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      isFinished: json['isFinished'] as bool);
}

Map<String, dynamic> _$TodoToJson(Todo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('time', instance.time?.toIso8601String());
  writeNotNull('isFinished', instance.isFinished);
  return val;
}
