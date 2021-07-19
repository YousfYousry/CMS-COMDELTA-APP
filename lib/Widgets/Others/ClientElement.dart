import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter/material.dart';

Widget clientElement(
    {BuildContext context,
    int index,
    String ID,
    String Details,
    String Location,
    String HighLight}) {
  return Column(
    children: [
      Container(
        height: 30,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SubstringHighlight(
                  text: ID,
                  term: HighLight,
                  textStyleHighlight: TextStyle(fontSize: 13,color: Colors.red, fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(fontSize: 12,color: Colors.black,),
                ),
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SubstringHighlight(
                  text: Details,
                  term: HighLight,
                  textStyleHighlight: TextStyle(fontSize: 13,color: Colors.red, fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(fontSize: 12,color: Colors.black,),                ),
                // Text(
                //   Details,
                //   textAlign: TextAlign.left,
                //   style: TextStyle(fontSize: 12),
                // ),
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SubstringHighlight(
                  text: Location,
                  term: HighLight,
                  textStyleHighlight: TextStyle(fontSize: 13,color: Colors.red, fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(fontSize: 12,color: Colors.black,),
                ),
                // Text(
                //   Location,
                //   textAlign: TextAlign.left,
                //   style: TextStyle(fontSize: 12),
                // ),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey,
      ),
    ],
  );
}
