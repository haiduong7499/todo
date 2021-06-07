import 'package:do_an/models/todo.dart';
import 'package:do_an/service/cate_service.dart';
import 'package:do_an/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _selectValue;
  var _category = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
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

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if(_pickedDate !=null){
      setState((){
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);

      });
    }
  }
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  _showSuccesSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Write Todo Title'),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Description', hintText: 'Write Todo Des'),
            ),
            TextField(
              controller: _todoDateController,
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
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var todoObject = Todo();
                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectValue.toString();
                todoObject.todoDate = _todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if(result>0){
                  _showSuccesSnackBar(Text('Created Todo Item Successed'));
                  print(result);
                }


              },
              color: Colors.blue,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
