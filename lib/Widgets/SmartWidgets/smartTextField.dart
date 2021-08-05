import 'package:flutter/material.dart';

class SmartField extends StatefulWidget {
  final controller;
  final onChanged;
  final errorText;
  final hintText;
  final keyboardType;

  SmartField(
      {this.controller,
      this.onChanged,
      this.errorText,
      this.hintText,
      this.keyboardType});

  @override
  _SmartField createState() => _SmartField();
}

class _SmartField extends State<SmartField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: [AutofillHints.name],
      keyboardType: widget.keyboardType == null
          ? TextInputType.text
          : widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorText: widget.errorText,
        hintText: widget.hintText,
        contentPadding:
            EdgeInsets.only(left: 15, top: 18, bottom: 18, right: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
