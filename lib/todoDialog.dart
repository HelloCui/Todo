import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDialog extends StatefulWidget {
  final title;
  final time;

  TodoDialog({this.title: '', this.time});

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  TextEditingController _titleCtrl;
  String _displayTime = '时间';
  DateTime _time;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.title);
    if (widget.time != null) {
      _time = widget.time;
      _displayTime = DateFormat('yyyy-MM-dd kk:mm').format(_time);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '标题',
                    contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20)),
                style: TextStyle(fontSize: 16, color: Colors.black),
                controller: _titleCtrl),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    _displayTime,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        color: _displayTime == '时间'
                            ? Theme.of(context).hintColor
                            : Colors.black),
                  )),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('保存'),
                    onPressed: () async {
                      _hide(context, result: [_titleCtrl.text, _time]);
                    },
                  ),
                  FlatButton(
                    highlightColor: Colors.white70,
                    child:
                        const Text('取消', style: TextStyle(color: Colors.grey)),
                    onPressed: () {
                      _hide(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectDate() async {
    final time = widget.time;
    DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: time != null ? time : new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2030));
    if (_pickedDate != null) {
      TimeOfDay _pickedTime = await showTimePicker(
          context: context,
          initialTime: time != null
              ? TimeOfDay.fromDateTime(time)
              : TimeOfDay(hour: TimeOfDay.now().hour, minute: 0));
      if (_pickedTime != null) {
        _time = new DateTime.utc(_pickedDate.year, _pickedDate.month,
            _pickedDate.day, _pickedTime.hour, _pickedTime.minute);
        setState(
            () => _displayTime = DateFormat('yyyy-MM-dd kk:mm').format(_time));
      }
    }
  }

  _hide(BuildContext context, {result}) {
    Navigator.pop(context, result);
  }
}

Future<List> showTodoDialog(BuildContext context,
    {String title: '', DateTime time}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new TodoDialog(title: title, time: time);
      });
}
