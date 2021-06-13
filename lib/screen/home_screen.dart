import 'package:do_an/helper/drawer_navi.dart';
import 'package:do_an/models/todo.dart';
import 'package:do_an/screen/todo_screen.dart';
import 'package:do_an/service/todo_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todolist = List<Todo>();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllTodos() async {
    _todoService = TodoService();
    _todolist = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];

        _todolist.add(model);
      });
    });
  }

  _deleteFormDialog(BuildContext context, todoId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  color: Colors.red,
                  onPressed: () async {
                    var result = await _todoService.deleteTodo(todoId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTodos();
                      _showSuccesSnackBar(Text('Deleted Success'));
                      print("Result : " + result);
                    }
                  },
                  child: Text('Delete')),
              FlatButton(
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'))
            ],
            title: Text('Do you want delete this item?'),
          );
        });
  }

  _showSuccesSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do App'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todolist[index].title ?? 'No Title'),
                    Text(_todolist[index].todoDate ?? 'No Date'),
                  ],
                ),
                subtitle: Text(_todolist[index].category ?? 'No Category'),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      _deleteFormDialog(context, _todolist[index].id);
                    }),
                onTap: () => {
                  print('onTap')
                },
              ),
            ),
          );
        },
        itemCount: _todolist.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
