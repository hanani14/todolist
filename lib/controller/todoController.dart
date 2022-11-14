import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';
class TodoController extends ChangeNotifier{
  bool _isFetching = false;
  bool get isFetching => _isFetching;
  
  late Map response;
  Map get getResponse => response;


 Map dummytodolist = {
    'Body':{
      'TODO_LIST':[
        {
          "TODO_ID": 1,
          "TODO_TITLE": "Go to Pasar",
          "TODO_DESC":"But fish, vegestable, squid",
          "TODO_DATE": DateTime(2022,11,11,06,30),
          "TODO_ISCHECKED": true
        },
         {
          "TODO_ID": 2,
          "TODO_TITLE": "Pay bills at poslaju",
          "TODO_DESC":"Bills electric & water",
          "TODO_DATE": DateTime(2022,11,12,06,30),
          "TODO_ISCHECKED": true
        },
         {
          "TODO_ID": 3,
          "TODO_TITLE": "Movie Night",
          "TODO_DESC":"Wakanda",
          "TODO_DATE": DateTime(2022,11,10,06,30),
          "TODO_ISCHECKED": false
        }
      ]
    }
 };

  Future<dynamic> fetchData({BuildContext? context}) async {
    _isFetching = true;
    notifyListeners();

    try {
      response = dummytodolist['Body'];


    } catch (f) {
      print(f);
    }

    _isFetching = false;
    notifyListeners();

    return response;
  }


List<Todo> updateList([res]){
  Map todolist = res['TODO_LIST'];
  return [Todo(id:todolist['TODO_ID'],title: todolist['TODO_TITLE'],date: todolist['TODO_DATE'], descriptions: todolist['TODO_DESC'],isComplete: todolist['TODO_ISCHECKED'])];
}



}