import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'todo.dart';
import 'todoDialog.dart';
import 'todoList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Todos';

    return MaterialApp(title: appTitle, home: MyHomePage(title: appTitle));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> _todoItems = [];

  Future _loadData() async {
    _todoItems = await Todo.fetchList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonePage()),
              );
            },
            child: Icon(Icons.history, color: Colors.white,),
          )
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          child: TodoList(
            items: _todoItems,
            completeCb: completeItem,
            deleteCb: deleteItem,
            updateCb: updateItem,
          ),
          onRefresh: _loadData,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          var result = await showTodoDialog(context);
          if (result != null) {
            var res = await Todo.add(new Todo(title: result[0], time: result[1]));
            if (res) {
              _loadData();
            }
          }
        },
        child: new Icon(Icons.add),
      ),
    );
  }

  Future completeItem(Todo item) async{
    item.isFinished = true;
    bool result = await item.update();
    if(result) {
      setState(() {
        _todoItems.remove(item);
      });
      return true;
    } else {
      return false;
    }
  }

  Future deleteItem(Todo item) async{
    bool result = await item.remove();
    if(result) {
      setState(() {
        _todoItems.remove(item);
      });
      return true;
    } else {
      return false;
    }
  }

  Future updateItem(Todo item) async{
    var result = await showTodoDialog(context, title: item.title, time: item.time);
    if (result != null) {
      item.title = result[0];
      item.time = result[1];
      await item.update();
      setState(() {});
    }
  }
}

class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  List<Todo> _todoItems = [];

  Future _loadData() async {
    _todoItems = await Todo.fetchDoneList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Done'),
        automaticallyImplyLeading: true
      ),
      body: Center(
        child: RefreshIndicator(
          child: TodoList(
            items: _todoItems,
            deleteCb: deleteItem,
          ),
          onRefresh: _loadData,
        ),
      ));
  }

  Future deleteItem(Todo item) async{
    bool result = await item.remove();
    if(result) {
      setState(() {
        _todoItems.remove(item);
      });
      return true;
    } else {
      return false;
    }
  }
}
