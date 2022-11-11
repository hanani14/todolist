import 'package:flutter/material.dart';
import 'package:todolist/global/checkbox.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body:  ListView.builder(
            itemCount:2,// material.length,
            itemBuilder: (context, index) {
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
                  child: CheckBoxList(completed: true,));
              //return MaterialTile(material: material[index]);
            },
          ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add)
      ),
    );
  }
}