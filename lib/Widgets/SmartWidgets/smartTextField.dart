import 'package:flutter/material.dart';

class SmartField extends StatefulWidget {
  final TextEditingController controller;
  final onChanged;
  final errorText;
  final title;
  final keyboardType;

  // final passVal;

  SmartField({
    this.controller,
    this.onChanged,
    this.errorText,
    this.title,
    this.keyboardType,
    // this.passVal,
  });

  @override
  _SmartField createState() => _SmartField();
}

class _SmartField extends State<SmartField> {
  // bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      SizedBox(
        height: 5,
      ),
      // Stack(
      //   alignment: Alignment.center,
      //   children: [
      TextField(
        autofillHints: [AutofillHints.name],
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        controller: widget.controller,
        onChanged: (text) {
          setState(() {
            widget.controller.text.isNotEmpty;
          });
          try {
            widget.onChanged(text);
          } catch (error) {}
        },
        decoration: InputDecoration(
          suffixIcon: widget.controller.text.isEmpty
              ? null // Show nothing if the text field is empty
              : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => widget.controller.clear()),
                ),
          fillColor: Colors.white,
          filled: true,
          errorText: widget.errorText,
          hintText: widget.title,
          contentPadding:
              EdgeInsets.only(left: 15, top: 18, bottom: 18, right: 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      //     Visibility(
      //       child: Align(
      //         alignment: Alignment.centerRight,
      //         child: Padding(
      //           padding: EdgeInsets.only(right: 7),
      //           child: Material(
      //             color: Colors.white,
      //             shape: RoundedRectangleBorder(
      //               side: BorderSide(width: 0.0, color: Colors.white),
      //               borderRadius: BorderRadius.circular(50.0),
      //             ),
      //             child: InkWell(
      //               customBorder: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(50.0),
      //               ),
      //               onTap: () => setState(() => widget.controller.clear()),
      //               child: Container(
      //                 padding: EdgeInsets.all(7),
      //                 child: Icon(Icons.clear),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       visible: false,
      //     ),
      //   ],
      // ),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}
