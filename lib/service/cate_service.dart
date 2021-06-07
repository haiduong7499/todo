import 'package:do_an/models/category.dart';
import 'package:do_an/repository/repository.dart';

class CateService{
  Repository _repository;
  CateService() {
    _repository = Repository();
  }
  saveCategory(Category category) async{
      return await _repository.insertData('categories', category.categoryMap());
      
  }
  
  readCategories() async{
    return await _repository.readData('categories');
  }

  readCategoryByID(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async{
    return await _repository.updateData('categories',category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories',categoryId);
  }
}