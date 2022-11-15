class Todo{
  int? id;
  // String? id;
  String? title;
  DateTime? date;
  String? descriptions;
  bool? isComplete;

  Todo({this.id,this.title,this.date,this.descriptions,this.isComplete});
}

List<Todo> todolist = [
Todo(title: "Go Grocery",date: DateTime(2022,11,2,06,30),isComplete:true, descriptions: "Buy fish,vegetable, gulgi" ),
Todo(title: "Breakfast",date: DateTime(2022,11,2,08,00),isComplete:true, descriptions: "f" ),
Todo(title: "Meeting",date: DateTime(2022,11,6,14,00),isComplete:true, descriptions: "Meeting with client" ),

];