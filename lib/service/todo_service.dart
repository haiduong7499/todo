
import 'package:do_an/models/todo.dart';
import 'package:do_an/repository/repository.dart';

class TodoService{
  Repository _repository;

  TodoService(){
    _repository = Repository();
  }
  
  saveTodo(Todo todo) async{
    return await _repository.insertData('todos', todo.todoMap());
  }
  
  readTodos() async{
    return await _repository.readData('todos');
  }
}