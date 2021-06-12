import 'package:do_an/models/todo.dart';
import 'package:do_an/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  TodosByCategory({this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  getTodosByCategory() async {
    var todos = await _todoService.readTodobyCate(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].title ?? 'No Title'),
                          ],
                        ),
                        subtitle: Text(_todoList[index].description ?? 'No Category'),
                        trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
