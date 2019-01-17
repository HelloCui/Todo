import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatefulWidget {
  final item;
  final completeCb;
  final deleteCb;
  final updateCb;
  TodoItem({this.item, this.completeCb, this.deleteCb, this.updateCb}): super(key: Key(item.id));

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  var _dragStart;
  double _translation = 0.0;
  int _multiple = 3;
  double _fullWidth = 0.0;
  bool _canDragRight = false;
  bool _canDragLeft = false;
  Color _bgColor = Colors.white;
  var _dragging;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _canDragRight = widget.completeCb != null;
    _canDragLeft = widget.deleteCb != null;
  }

  @override
  Widget build(BuildContext context) {
    _fullWidth = MediaQuery.of(context).size.width;
    return new GestureDetector(
        onLongPress: _onLongPress,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: <Widget>[
            Transform(
              transform: new Matrix4.translationValues(_translation, 0.0, 0.0),
              child: ListTile(
                title: Text(widget.item.title),
                subtitle: Text(DateFormat('yyyy-MM-dd kk:mm').format(widget.item.time)),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: _translation > 0 ? 0 : (_fullWidth - _translation.abs() * _multiple),
              right: _translation > 0 ? (_fullWidth - _translation.abs() * _multiple) : 0,
              child: Container(
                color: _bgColor
              ),
            ),
          ],
        )
    );
  }

  _onDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_dragStart != null) {
      final newPosition = details.globalPosition;
      if(newPosition.dx > _dragStart.dx && _canDragRight) {
        _bgColor = Color.fromRGBO(0, 220, 0, 0.3);
        _dragging = 'right';
      } else if(newPosition.dx < _dragStart.dx && _canDragLeft) {
        _bgColor = Color.fromRGBO(220, 0, 0, 0.3);
        _dragging = 'left';
      } else {
        return;
      }
      setState(() {
        _translation =  newPosition.dx - _dragStart.dx;
      });
    }
  }

  _onDragEnd(DragEndDetails details) {
    if(_dragging != null && _fullWidth - _translation.abs() * _multiple <= 0) {
      if(_dragging == 'right') {
        widget.completeCb(widget.item);
      } else if(_dragging == 'left') {
        widget.deleteCb(widget.item);
      }
    } else {
      _translation = 0.0;
      _dragStart = null;
      _dragging = null;
    }
  }

  _onLongPress() {
    if(widget.updateCb != null) {
      widget.updateCb(widget.item);
    }
  }
}