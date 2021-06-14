import 'package:do_an/helper/drawer_navi.dart';
import 'package:do_an/models/todo.dart';
import 'package:do_an/screen/todo_screen.dart';
import 'package:do_an/service/cate_service.dart';
import 'package:do_an/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todolist = List<Todo>();

  @override
  initState() {
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
    getAllTodos();
    _loadCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var _todo = Todo();
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

  var _editTodoNameController = TextEditingController();
  var _editTodoDescriptionController = TextEditingController();
  var _edittodoDateController = TextEditingController();
  var _selectValue;
  var todo;
  var _category = List<DropdownMenuItem>();
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _edittodoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  _editTodo(BuildContext context, todoId) async {
    todo = await _todoService.readTodobyId(todoId);
    setState(() {
      _editTodoNameController.text = todo[0]['title'] ?? 'No Title';
      _editTodoDescriptionController.text =
          todo[0]['description'] ?? 'No Description';
      _edittodoDateController.text = todo[0]['todoDate'] ?? 'No Date';
    });
    _editFormDialog(context);
  }
  _loadCategories() async {
    var _categoryService = CateService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _category.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    _todo.id = todo[0]['id'];
                    _todo.title = _editTodoNameController.text;
                    _todo.description =
                        _editTodoDescriptionController.text;
                    _todo.category = _selectValue.toString();
                    _todo.todoDate = _edittodoDateController.text;
                    var result = await _todoService.updateCategory(_todo);
                    if(result>0){
                      Navigator.pop(context);
                      getAllTodos();
                      _showSuccesSnackBar(Text('Updated Success'));
                    }
                  },
                  child: Text('Update')),
              FlatButton(
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'))
            ],
            title: Text('Edit Todo Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editTodoNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a Title', labelText: 'Title'),
                  ),
                  TextField(
                    controller: _editTodoDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a Description',
                        labelText: 'Description'),
                  ),
                  DropdownButtonFormField(
                    value: _selectValue,
                    items: _category,
                    onChanged: (value) {
                      setState(() {
                        _selectValue = value;
                      });
                    },
                    hint: Text('Category'),
                  ),
                  TextField(
                    controller: _edittodoDateController,
                    decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: 'Pick a Date',
                        prefix: InkWell(
                          onTap: () {
                            _selectedTodoDate(context);
                          },
                          child: Icon(Icons.calendar_today),
                        )),
                  ),
                ],
              ),
            ),
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
                leading: IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.blue,
                  onPressed: () {
                    displayNotification('hãy hoàn thành:' +
                        _todolist[index].title +
                        ' có những yêu cầu sau ' +
                        _todolist[index].description);
                    print('reng reng');
                  },
                ),
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
                onTap: () => {_editTodo(context, _todolist[index].id)},
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

  // , DateTime dateTime
  // dateTime,
  Future<void> displayNotification(String match) async {
    notificationsPlugin.zonedSchedule(
        0,
        match,
        'Notifycation',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'channel id', 'channel name', 'channel description'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('my_logo');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}
