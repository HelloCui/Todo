import 'package:flutter/material.dart';
import './todoItem.dart';


class TodoList extends StatefulWidget {
  final List items;
  final completeCb;
  final deleteCb;
  final updateCb;

  TodoList({Key key, this.items, this.completeCb, this.deleteCb, this.updateCb}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return TodoItem(item: item, completeCb: widget.completeCb, deleteCb: widget.deleteCb, updateCb: widget.updateCb);
        });
  }
}