import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/Pages/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

String title = "Add Client";

class AddClient extends StatefulWidget {
  AddClient({title});

  @override
  _AddClient createState() => _AddClient();
}

class _AddClient extends State<AddClient> {

  List <String> spinnerItems = [
    'Hidden',
    'Shown',
  ] ;
  bool loading = !title.contains("Add");

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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBarBack(context, title),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, SizeRoute(page: DashBoard()));
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.indigoAccent,
        ),

        // drawer: SideDrawerAdmin(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Client Name',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      // controller: firstName,
                      decoration: InputDecoration(
                        hintText: 'Client Name',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Address',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      // controller: firstName,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Contact No',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      // controller: firstName,
                      decoration: InputDecoration(
                        hintText: 'Contact No',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Email',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      // controller: firstName,
                      decoration: InputDecoration(
                        hintText: 'Emails',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Active Device Last 72 Hours\n(Dashboard)',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      // controller: firstName,
                      decoration: InputDecoration(
                        hintText: 'Emails',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Inactive Device Last 72 Hours\n(Dashboard)',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),

                    DropdownButton<String>(
                      // value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String data) {
                        setState(() {
                          // dropdownValue = data;
                        });
                      },
                      items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // TextField(
                    //   // The validator receives the text that the user has entered.
                    //   autofillHints: [AutofillHints.name],
                    //   keyboardType: TextInputType.text,
                    //   // controller: firstName,
                    //   decoration: InputDecoration(
                    //     hintText: 'Emails',
                    //     contentPadding: EdgeInsets.all(15),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(0.0),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Center(
              child: Visibility(
                child: CircularProgressIndicatorApp(),
                visible: loading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}
