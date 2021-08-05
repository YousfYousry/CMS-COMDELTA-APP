import 'dart:math';
import 'package:flutter/material.dart';

class AddEntryDialog extends StatefulWidget {
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xff0065a3),
        title: const Text('Advanced Search'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.autorenew,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextField()
          ],
        ),
      ),
    );
  }
}