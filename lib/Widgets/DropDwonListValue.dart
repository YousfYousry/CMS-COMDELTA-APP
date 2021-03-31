import 'package:flutter/material.dart';

class DropDownListValue extends StatefulWidget {
  @override
  _DropDownListValueState createState() => _DropDownListValueState();
}

class _DropDownListValueState extends State<DropDownListValue> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
          
          color: Colors.white,
          border: Border.all(
            color: Colors.grey
          )),
      child: DropdownButton(
        value: _value,
        items: [
          DropdownMenuItem(
            child: Text("10"),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text("25"),
            value: 2,
          ),
          DropdownMenuItem(
            child: Text("50"),
            value: 3,
          ),
          DropdownMenuItem(
            child: Text("All"),
            value: 4,
          ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
      ),
    ));
  }
}
