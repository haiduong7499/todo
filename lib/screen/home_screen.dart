import 'package:do_an/helper/drawer_navi.dart';
import 'package:do_an/models/todo.dart';
import 'package:do_an/screen/todo_screen.dart';
import 'package:do_an/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todolist = List<Todo>();
  CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff38044B), fontWeight: fontWeight);
  }

  Container taskList(
      String title, String description, IconData iconImg, Color iconColor) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(children: <Widget>[
        Icon(
          iconImg,
          color: iconColor,
          size: 30,
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: (TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff38044B))),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                description,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        )
      ]),
    );
  }

  @override
  initState() {
    super.initState();
    getAllTodos();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff38044B),
      ),
      drawer: DrawerNavigation(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                    weekdayStyle: dayStyle(FontWeight.bold),
                    weekendStyle: TextStyle(
                        color: Color(0xffC9B5D4), fontWeight: FontWeight.bold),
                    selectedColor: Color(0xff38044B),
                    todayColor: Colors.white.withAlpha(0),
                    todayStyle: TextStyle(
                        color: Color(0xFFF80303), fontWeight: FontWeight.bold)),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: Color(0xff38044B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    weekendStyle: TextStyle(
                        color: Color(0xffC9B5D4),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    dowTextBuilder: (date, locale) {
                      return DateFormat.E(locale).format(date).substring(0, 1);
                    }),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        color: Color(0xff79378B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xff79378B),
                    ),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Color(0xff79378B))),
                calendarController: _controller,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular((50)),
                        topRight: Radius.circular((50))),
                    color: Color(0xffC9B5D4)),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "Today",
                          style: TextStyle(
                              color: Color(0xff38044B),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var i = 0; i < _todolist.length; i++)
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(children: <Widget>[
                            IconButton(
                                icon: Icon(CupertinoIcons.check_mark_circled_solid),
                                color: Color(0xffF9F400),
                                onPressed: () {
                                  _deleteFormDialog(context, _todolist[i].id);
                                }),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _todolist[i].title ?? 'No Title',
                                    style: (TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff38044B))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _todolist[i].description ?? 'No Category',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                            Color(0xffC9B5D4).withAlpha(0),
                            Color(0xffC9B5D4)
                          ],
                              stops: [
                            0.0,
                            1.0
                          ])),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      //       child: Card(
      //         elevation: 8,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(0)),
      //         child: ListTile(
      //           title: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: <Widget>[
      //               Text(_todolist[index].title ?? 'No Title'),
      //               Text(_todolist[index].todoDate ?? 'No Date'),
      //             ],
      //           ),
      //           subtitle: Text(_todolist[index].description ?? 'No Category'),
      //           trailing: IconButton(
      //               icon: Icon(Icons.delete),
      //               color: Colors.red,
      //               onPressed: () {
      //                 _deleteFormDialog(context, _todolist[index].id);
      //               }),
      //         ),
      //       ),
      //     );
      //   },
      //   itemCount: _todolist.length,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        backgroundColor: Color(0xff38044B),
        child: Icon(Icons.add),
      ),
    );
  }

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
}
