import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CheckBoxList extends StatefulWidget {
  String? title;
  DateTime? date;
  bool? completed;
   CheckBoxList({super.key,this.date,this.title,this.completed});

  @override
  State<CheckBoxList> createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile( subtitle: Text('${widget.date.toString()}'),
      value: widget.completed,
      title: Text('${widget.title}'),
      onChanged: ( isChecked) {
       
      },
    );
  }
}