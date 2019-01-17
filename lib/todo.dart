import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'dio.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  String id;
  String title;
  DateTime time;
  bool isFinished;

  Todo({this.id, this.title, this.time, this.isFinished});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  // 获取列表数据
  static Future fetchList() async {
    try {
      final response = await dio.get('/todos');
      if (response.statusCode == 200) {
        return Todo.parseList(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch(e) {
      print(e);
    }
  }

  // 获取已完成列表数据
  static Future fetchDoneList() async {
    try {
      final response = await dio.get('/todos/done');
      if (response.statusCode == 200) {
        return Todo.parseList(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch(e) {
      print(e);
    }
  }

  // 将列表数据从json转换成对象集合
  static List<Todo> parseList(data) {
    return data.map<Todo>((json) => Todo.fromJson(json)).toList();
  }

  static Future add(Todo item) async {
    final res =
        await dio.post('/todo', data: item.toJson());
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future update() async {
    try {
      final res = await dio.put('/todo/${this.id}', data: this.toJson());
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
    }
  }

  Future remove() async {
    try {
      final res = await dio.delete('/todo/${this.id}');
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
    }
  }
}
