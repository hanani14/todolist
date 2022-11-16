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


import 'dart:collection';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/controller/todoController.dart';
import 'package:todolist/global/checkbox.dart';
import 'package:todolist/global/loading.dart';
import 'package:todolist/global/utils.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/view/addtodo_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with SingleTickerProviderStateMixin {
  
  late TextEditingController _controller1;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String errortext = '';

  final _formKey = GlobalKey<FormState>();
  final _titlee = TextEditingController();
  final _desc = TextEditingController();

  

  late final PageController _pageController;
  late final ValueNotifier<List<Todo>> _selectedEvents;
 
  late AnimationController? _animationController;


  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
   DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late LinkedHashMap<DateTime?, List<Todo>>kevent = LinkedHashMap<DateTime?, List<Todo>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  late final kToday = DateTime.now();
  late final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
  late final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
  bool _isLoading =false;
  late Map<DateTime?, List<Todo>> _events;


  @override
  void initState() {
  Future.delayed(Duration.zero,()async{
   await Provider.of<TodoController>(context, listen: false).fetchData(context: context);  
       getEvent();

   });   
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // TODO: implement initState
    super.initState();
  }

 allEvent(title, id, details, summary, status,dd,eve,date){
   Map<DateTime, List<Todo>> _kEventSource = { for (var item in List.generate(10, (index) => index)) dd : List.generate(
            item % 4 + 1, (index) =>Todo(title: title,id:id,date: date, descriptions: details,isComplete: status,)// 
          ) };
 kevent.addAll(_kEventSource);
  }


getEvent()async{
   var todos = await Provider.of<TodoController>(context, listen: false).getTodoList;
      _events = {
      _selectedDay: [],
    };

print(todos);
      for (int i = 0; i < todos.length; i++) {
      _events.update(
            todos[i].date!,
            (previousEvents) => previousEvents..add( Todo(
                title:  todos[i].title,
                id:todos[i].id,
                date: todos[i].date,
                descriptions: todos[i].descriptions,
                isComplete: todos[i].isComplete,
              )),
            ifAbsent: () => [ Todo(
                title:  todos[i].title,
                id:todos[i].id,
                date: todos[i].date,
                descriptions: todos[i].descriptions,
                isComplete: todos[i].isComplete,
              )],
            );
       kevent.addAll(_events);
      }
      _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController!.forward();

    setState(() {
      _isLoading = false;
    });

    print('mm ${kevent.toString()}') ;
}


@override
void dispose() {
  //  _focusedDay.dispose();
  _selectedEvents.dispose();
  _animationController!.dispose();
  super.dispose();
}


  List<Todo> _getEventsForDay(DateTime day) {
    return kevent[day] ?? [];
  }

  List<Todo> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Todo> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }


  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print("calendar 2 $_selectedEvents");
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }


  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
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
        widget1 = Scaffold( appBar: AppBar(title: const Text('Todo List')),
          body:  
            Container(
                padding: const EdgeInsets.only(
                  top: 0.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _isLoading == true
                              ? Loading()
                              : ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TableCalendar(
                                                locale: 'en_US',
                                                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                                eventLoader: _getEventsForDay,
                                                calendarFormat:  CalendarFormat.month,
                                                startingDayOfWeek: StartingDayOfWeek.sunday,
                                                availableCalendarFormats: const {
                                                  CalendarFormat.month: '',
                                                  CalendarFormat.week: '',
                                                },
                                                calendarStyle: CalendarStyle(
                                                  outsideDaysVisible: false,
                                                  weekNumberTextStyle: const TextStyle().copyWith(color: Colors.red[800]),
                                                  holidayTextStyle: const TextStyle().copyWith(color: Colors.red[800]),
                                                ),
                                                daysOfWeekStyle: DaysOfWeekStyle(
                                                  weekendStyle: const TextStyle().copyWith(color: Colors.red[600]),
                                                ),
                                                headerStyle: const HeaderStyle(
                                                  titleCentered: true,
                                                  formatButtonVisible: false,
                                                ),
                                                onDaySelected: (date, events, ) {
                                                  _onDaySelected(date, events);
                                                  _animationController!.forward(from: 0.0);
                                                },
                                                calendarBuilders: CalendarBuilders(
                                                  selectedBuilder:(context, date, _) {
                                                    return FadeTransition(
                                                      opacity:
                                                          Tween(begin: 0.0, end: 1.0).animate(_animationController!),
                                                      child: Container(
                                                        margin: const EdgeInsets.all(4.0),
                                                        padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                                                        color: Colors.deepOrange[300],
                                                        width: 100,
                                                        height: 100,
                                                        child: Text(
                                                          '${date.day}',
                                                          style: const TextStyle().copyWith(fontSize: 16.0),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                   
                                                  todayBuilder: 
                                                  (context, date, _) {
                                                    return Container(
                                                      margin: const EdgeInsets.all(4.0),
                                                      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                                                      color: Colors.amber[400],
                                                      width: 100,
                                                      height: 100,
                                                      child: Text(
                                                        '${date.day}',
                                                        style: const TextStyle().copyWith(fontSize: 16.0),
                                                      ),
                                                    );
                                                  },
                                                  markerBuilder: (context, date, events) {
                                                    if (events.isNotEmpty) {
                                                      return 
                                                        Positioned(
                                                          right: 1,
                                                          bottom: 1,
                                                          child: AnimatedContainer(
                                                            duration: const Duration(milliseconds: 300),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.rectangle,
                                                              color: Colors.blue[400],
                                                            ),
                                                            width: 16.0,
                                                            height: 16.0,
                                                            child: Center(
                                                              child: Text(
                                                                '${events.length}',
                                                                style: const TextStyle().copyWith(
                                                                  color: Colors.white,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                    
                                                    }else{
                                                      return SizedBox();
                                                    }
                                                  },
                                                ), 
                                                firstDay: kFirstDay,
                                                focusedDay: _focusedDay,
                                                lastDay: kLastDay,
                                              ),
                                            ),
                                          ],
                                        ),
                                                    ListView(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.vertical,
                                                      children: _selectedEvents.value
                                                          .map((event) => Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(width: 0.8),
                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                ),
                                                                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                            child: ListTile(isThreeLine: true,
                                                              subtitle: Text("Date: ${event.date}\nDescription: ${event.descriptions}  "),
                                                              title: 
                                                              Dismissible(
                                                                key: UniqueKey(),
                                                                child: Text('${event.title}'),
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
                                                            
                                                            
                                                              ),
                                                            ),
                                                          )
                                                          ).toList()),
                                      ],
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ],
                )),


          // ListView.builder(
          //   itemCount:todotask.length,// material.length,
          //   itemBuilder: (context, index) {
          //     final todoitem = todo.getTodoList[index];
          //     return Dismissible(
          //         // tarik ke kiri untuk delete
          //         key: UniqueKey(),
          //         onDismissed: (direction) async {
          //           // await ManageMaterialServices().deleteImageC(
          //           //     material[index].fileID, material[index].file);
          //         },
          //         secondaryBackground: Container(
          //           color: Colors.pink[300],
          //           child: Align(
          //             alignment: Alignment.centerRight,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: const <Widget>[
          //                 Icon(
          //                   Icons.edit,
          //                   color: Colors.white,
          //                 ),
          //                 Text(
          //                   "Edit",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.w700,
          //                   ),
          //                   textAlign: TextAlign.right,
          //                 ),
          //                 SizedBox(
          //                   width: 20,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         background: Container(
          //           color: Colors.red,
          //           child: Align(
          //             alignment: Alignment.centerRight,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: const <Widget>[
          //                 Icon(
          //                   Icons.remove,
          //                   color: Colors.white,
          //                 ),
          //                 Text(
          //                   "Delete",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.w700,
          //                   ),
          //                   textAlign: TextAlign.right,
          //                 ),
          //                 SizedBox(
          //                   width: 20,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         child: CheckBoxList(completed: todoitem.isComplete,title: todoitem.title,date: todoitem.date,));
          //  },),

            floatingActionButton:  FloatingActionButton(
              onPressed: (){
                 Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addnew()));},
                // _showDialog();} ,
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