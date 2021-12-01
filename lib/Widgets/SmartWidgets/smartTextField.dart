import 'package:flutter/material.dart';

class SmartField extends StatefulWidget {
  final TextEditingController controller;
  final onChanged;
  final errorText;
  final title;
  final keyboardType;
  final filled;
  final opacity;
  final obscureText;
  final titled;

  SmartField({
    this.controller,
    this.onChanged,
    this.errorText,
    this.title,
    this.keyboardType = TextInputType.text,
    this.filled = true,
    this.opacity = 1.0,
    this.obscureText = false,
    this.titled = true,
  });

  @override
  _SmartField createState() => _SmartField();
}

class _SmartField extends State<SmartField> {
  // bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Visibility(
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black.withOpacity(widget.opacity)),
          ),
          visible: widget.titled),
      SizedBox(
        height: (widget.titled) ? 5 : 0,
      ),
      // Stack(
      //   alignment: Alignment.center,
      //   children: [
      TextField(
        autofillHints: [AutofillHints.name],
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        onChanged: (text) {
          setState(() {
            widget.controller.text.isNotEmpty;
          });
          try {
            widget.onChanged(text);
          } catch (error) {}
        },
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          suffixIcon: widget.controller.text.isEmpty
              ? null // Show nothing if the text field is empty
              : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => widget.controller.clear()),
                ),
          fillColor: Colors.white,
          filled: widget.filled,
          errorText: widget.errorText,
          hintText: widget.title,
          contentPadding:
              EdgeInsets.only(left: 15, top: 18, bottom: 18, right: 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black.withOpacity(widget.opacity)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Colors.black.withOpacity(widget.opacity)),
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
