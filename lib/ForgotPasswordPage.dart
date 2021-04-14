import 'package:flutter/material.dart';

import './Widgets/CustomeAppBar.dart';
import './Widgets/SideDrawer.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
      ),
    );
  }
}
