// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todolist/controller/todoController.dart';
// import 'package:todolist/global/checkbox.dart';
// import 'package:todolist/global/loading.dart';

// class TodoPage extends StatefulWidget {
//   const TodoPage({super.key});

//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }

// class _TodoPageState extends State<TodoPage> {
//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//       appBar: AppBar(title: const Text('Todo List')),
//       body: Consumer<TodoController>(builder: (context, todo, child) {
//         if( todo ==null){
//           return Loading();
//         }
//         else{
//    ListView.builder(
//             itemCount:2,// material.length,
//             itemBuilder: (context, index) {
//               return Dismissible(
//                   // tarik ke kiri untuk delete
//                   key: UniqueKey(),
//                   // direction: DismissDirection.endToStart,
//                   onDismissed: (direction) async {
//                     // await ManageMaterialServices().deleteImageC(
//                     //     material[index].fileID, material[index].file);
//                   },
//                   secondaryBackground: Container(
//                     color: Colors.pink[300],
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: const <Widget>[
//                           Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             "Edit",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                             ),
//                             textAlign: TextAlign.right,
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   background: Container(
//                     color: Colors.red,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: const <Widget>[
//                           Icon(
//                             Icons.remove,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             "Delete",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                             ),
//                             textAlign: TextAlign.right,
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   child: CheckBoxList(completed: true,));
//               //return MaterialTile(material: material[index]);
//             },
//           );
//         }
//       },)
      
      
    
//       floatingActionButton: const FloatingActionButton(
//         onPressed: null,
//         child: Icon(Icons.add)
//       ),
//     );
//   }
// }


import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controller/todoController.dart';
import 'package:todolist/global/checkbox.dart';
import 'package:todolist/global/loading.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  
  late TextEditingController _controller1;
  String _valueChanged1 = '';
String _valueToValidate1 = '';
  String _valueSaved1 = '';
    String errortext = '';

    final _formKey = GlobalKey<FormState>();
      final _nameFile = TextEditingController();



  @override
  void initState() {
  Future.delayed(Duration.zero,(){
    Provider.of<TodoController>(context, listen: false).fetchData(context: context);  });   
    _controller1 = TextEditingController(text: DateTime.now().toString());

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Consumer<TodoController>(builder: (context, todo, child) {
      Widget widget1;
      if(todo == null && todo.isFetching){
        widget1 = Scaffold(
           appBar: AppBar(title: const Text('Todo List')),
           body: const Loading(),
        );
      }
      else {
        var todotask = todo.getTodoList;
        print('lengthh ${todotask.length}');
        widget1 = Scaffold(
           appBar: AppBar(title: const Text('Todo List')),
          body:  ListView.builder(
            itemCount:todotask.length,// material.length,
            itemBuilder: (context, index) {
              final todoitem = todo.getTodoList[index];
              return Dismissible(
                  // tarik ke kiri untuk delete
                  key: UniqueKey(),
                  // direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    // await ManageMaterialServices().deleteImageC(
                    //     material[index].fileID, material[index].file);
                  },
                  secondaryBackground: Container(
                    color: Colors.pink[300],
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: CheckBoxList(completed: todoitem.isComplete,title: todoitem.title,date: todoitem.date,));
           },),

            floatingActionButton:  FloatingActionButton(
              onPressed: (){
                _showDialog();} ,
              child: const Icon(Icons.add)
            ),
          
        );
      }

      return widget1;
    },);
  }


   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          child:Form(key: _formKey,child: 
          
           Column(
            children: [
              Card(
                      // color: Colors.deepPurple[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                //color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(10),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.black12,
                                //       blurRadius: 3,
                                //       offset: Offset(2, 2))
                                // ]
                              ),
                              child: TextFormField(
                                controller: _nameFile,
                                validator: (val) =>
                                    val!.isEmpty ? errortext : null,
                                // onChanged: (val) => title = val,
                                decoration: InputDecoration(
                                  labelText: "Title",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.deepPurple[200]!,
                                  )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purpleAccent[100]!)),
                                ),
                              ),
                            ),
                           
                            SizedBox(height: 8),
                            
                          ],
                        ),
                      ),
                    ),
               Container(
                 child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  controller: _controller1,
                  //initialValue: _initialValue,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  //use24HourFormat: false,
                  //locale: Locale('pt', 'BR'),
                  selectableDayPredicate: (date) {
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }
                    return true;
                  },
                  onChanged: (val) => setState(() => _valueChanged1 = val),
                  validator: (val) {
                    setState(() => _valueToValidate1 = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
              ),
               ),
            ],
          ),
          )
          
          
          
         
          
        );
      },
    );
  }
  
}

//  title: const Text("Alert Dialog title"),
//           content: const Text("Alert Dialog body"),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             // ignore: unnecessary_new
//             new TextButton(
//               child: const Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),