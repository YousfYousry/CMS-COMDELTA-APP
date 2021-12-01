import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../public.dart';

class SmartDate extends StatefulWidget {
  final TextEditingController controller;
  final hintText;

  SmartDate({this.controller, this.hintText});

  @override
  _SmartDate createState() => _SmartDate();
}

class _SmartDate extends State<SmartDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hintText,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onTap: () => _selectDate(context),
            child: TextField(
              controller: widget.controller,
              enabled: false,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                contentPadding:
                    EdgeInsets.only(left: 15, top: 18, bottom: 18, right: 15),
              ),
            ),
          ),
        ),
        Visibility(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 7),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.0, color: Colors.white),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  onTap: () => setState(() => widget.controller.clear()),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    child: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
          visible: widget.controller.text.isNotEmpty,
        ),
      ],
    ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.controller.text.isEmpty
          ? DateTime.now()
          : DateFormat('dd-MM-yyyy').parse(widget.controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      fieldHintText: widget.hintText,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(0xff0065a3, customColors),
              primaryColorDark: Color(0xff0065a3),
              accentColor: Color(0xff0065a3),
            ),
            dialogBackgroundColor: Colors.white,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          child: child,
        );
      },
    );

    if (pickedDate != null)
      setState(() {
        widget.controller.text = formatDate(pickedDate);
      });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
