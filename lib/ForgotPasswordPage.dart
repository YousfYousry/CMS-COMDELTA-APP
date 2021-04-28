import 'package:flutter/material.dart';
import './Widgets/ForgotPasswordform.dart';
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
          child: CustomeAppBar('Change Password'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 660,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      heightFactor: 2,
                      child: Text(
                        'Change your information',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ForgotPasswordForm(),
                    ),
                    SizedBox(height: 40),
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
