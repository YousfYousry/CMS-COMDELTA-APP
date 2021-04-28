import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Widgets/CustomeFormFeedBack.dart';
import 'Widgets/SideDrawer.dart';
import 'Widgets/CustomeAppBar.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: PreferredSize(
          child: CustomeAppBar('Feedback'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      heightFactor: 2,
                      child: Text(
                        'Feedback Report',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: FeedBackForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
