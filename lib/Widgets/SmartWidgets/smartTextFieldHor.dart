import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmartFieldH extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController controller2;
  final onChanged;
  final onChanged2;
  final errorText;
  final errorText2;
  final title;
  final hint1;
  final hint2;
  final keyboardType;
  final keyboardType2;

  // final passVal;

  SmartFieldH({
    this.controller,
    this.onChanged,
    this.errorText,
    this.title,
    this.keyboardType,
    this.controller2,
    this.hint1,
    this.hint2,
    this.onChanged2,
    this.errorText2,
    this.keyboardType2,
  });

  @override
  _SmartField createState() => _SmartField();
}

class _SmartField extends State<SmartFieldH> {
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

      Row(
        children: [
          Expanded(
            child: TextField(
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
                hintText: widget.hint1,
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
            child:TextField(
              autofillHints: [AutofillHints.name],
              keyboardType: widget.keyboardType2 == null
                  ? TextInputType.text
                  : widget.keyboardType2,
              controller: widget.controller2,
              onChanged: (text) {
                setState(() {
                  widget.controller2.text.isNotEmpty;
                });
                try {
                  widget.onChanged2(text);
                } catch (error) {}
              },
              decoration: InputDecoration(
                suffixIcon: widget.controller2.text.isEmpty
                    ? null // Show nothing if the text field is empty
                    : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => widget.controller2.clear()),
                ),
                fillColor: Colors.white,
                filled: true,
                errorText: widget.errorText2,
                hintText: widget.hint2,
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
            )
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}
