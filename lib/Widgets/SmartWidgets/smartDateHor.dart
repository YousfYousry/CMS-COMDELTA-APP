import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../public.dart';
import 'dart:math' as math;

class SmartDateH extends StatefulWidget {
  final TextEditingController controller, controller2;
  final title, hintText, hintText2;

  SmartDateH(
      {this.controller,
      this.controller2,
      this.hintText,
      this.hintText2,
      this.title});

  @override
  _SmartDate createState() => _SmartDate();
}

class _SmartDate extends State<SmartDateH> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Stack(
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
                      onTap: () => selectDate(context),
                      child: TextField(
                        controller: widget.controller,
                        enabled: false,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: widget.hintText,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 18, bottom: 18, right: 15),
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
                            onTap: () =>
                                setState(() => widget.controller.clear()),
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
            ),
            Padding(
              padding: EdgeInsets.only(right: 2,left: 2),
              child: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: Icon(
                  Icons.height,
                  size: 22,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: Stack(
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
                      onTap: () => selectDate2(context),
                      child: TextField(
                        controller: widget.controller2,
                        enabled: false,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: widget.hintText2,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16),
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 18, bottom: 18, right: 15),
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
                            onTap: () =>
                                setState(() => widget.controller2.clear()),
                            child: Container(
                              padding: EdgeInsets.all(7),
                              child: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                    ),
                    visible: widget.controller2.text.isNotEmpty,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.controller.text.isEmpty
          ? DateTime.now()
          : DateFormat('dd-MM-yyyy').parse(widget.controller.text),
      firstDate: DateTime(2000),
      lastDate: widget.controller2.text.isNotEmpty
          ? DateFormat('dd-MM-yyyy').parse(widget.controller2.text)
          : DateTime.now(),
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

  Future<void> selectDate2(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.controller2.text.isEmpty
          ? DateTime.now()
          : DateFormat('dd-MM-yyyy').parse(widget.controller2.text),
      firstDate: widget.controller.text.isNotEmpty
          ? DateFormat('dd-MM-yyyy').parse(widget.controller.text)
          : DateTime.now(),
      lastDate: DateTime(2050),
      fieldHintText: widget.hintText2,
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
        widget.controller2.text = formatDate(pickedDate);
      });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
