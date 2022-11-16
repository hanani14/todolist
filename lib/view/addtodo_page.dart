
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controller/todoController.dart';
import 'package:todolist/model/todo.dart';

class Addnew extends StatefulWidget {
  const Addnew({super.key});

  @override
  State<Addnew> createState() => _AddnewState();
}

class _AddnewState extends State<Addnew> {
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String errortext = '';
  late TextEditingController _controller1;

  final _formKey = GlobalKey<FormState>();
  final _titlee = TextEditingController();
  final _desc = TextEditingController();



  @override
  void initState() {  
      _controller1 = TextEditingController(text: DateTime.now().toString());

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: const Text('Todo List')),      
          body: Form(key: _formKey,child: 
          
           Container(height: 270,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                
                children: [
                  Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: _titlee,
                                    validator: (val) =>
                                        val!.isEmpty ? errortext : null,
                                    // onChanged: (val) => title = val,
                                    decoration: InputDecoration(
                                      labelText: "Title",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.pink[200]!,
                                      )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.pink[900]!)),
                                    ),
                                  ),
                                ),
                               
                                SizedBox(height: 8),
                                  Container(
                                  height: 40,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: _desc,
                                    validator: (val) =>
                                        val!.isEmpty ? errortext : null,
                                    // onChanged: (val) => title = val,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.pink[200]!,
                                      )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.pink[900]!)),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                   Padding(
                     padding: const EdgeInsets.only(left:8.0,right: 8.0),
                     child: Container(
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
                        onChanged: (val) { setState(() => _valueChanged1 = val);
                        print('Datee: $_valueChanged1');},
                        validator: (val) {
                          setState(() => _valueToValidate1 = val ?? '');
                          return null;
                        },
                        onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
                  ),
                     ),
                   ),
                   SizedBox(height: 25),

                   ElevatedButton(onPressed: ()async{
                   TodoController().addList(Todo(title:_titlee.text,date: DateTime.parse(_valueChanged1),descriptions: _desc.text ));
                   Provider.of<TodoController>(context, listen: false).fetchData(context: context);  
                   Navigator.pop(context);

                   }, child: Text('Add'))
                ],
          ),
             ),
           ),
          ),
    );
  }
}