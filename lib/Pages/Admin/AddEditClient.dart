import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/JasonHolders/ClientJason.dart';
// import 'package:login_cms_comdelta/Pages/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
// import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

class AddClient extends StatefulWidget {
  final String title;
  final ClientJason client;

  AddClient({this.title, this.client});

  @override
  _AddClient createState() => _AddClient(title, client);
}

class _AddClient extends State<AddClient> {
  String dropdownValue = "Hidden";
  String dropdownValue2 = "Hidden";
  TextEditingController clientName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController email = TextEditingController();
  String title;
  final ClientJason client;

  _AddClient(this.title, this.client) {
    if (this.title == null || this.title.isEmpty) {
      this.title = "Add Client";
    }else if (this.client != null) {
      dropdownValue = (client.statTwo.contains("0")) ? "Shown" : "Hidden";
      dropdownValue2 = (client.statThree.contains("0")) ? "Shown" : "Hidden";
      clientName.text = client.clientName;
      address.text = client.clientAddress;
      contactNum.text = client.clientContact;
      email.text = client.clientEmail;
    }
  }

  List<String> spinnerItems = [
    'Hidden',
    'Shown',
  ];

  // bool loading = !title.contains("Add");
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    void unFocus() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }
    }

    return GestureDetector(
      onTap: () => unFocus(),
      child: Scaffold(
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: CustomAppBarBack(context, title),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {



          },
          child: const Icon(Icons.save),
          backgroundColor: Color(0xff0065a3),
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
                      controller: clientName,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Client Name',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                      controller: address,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Address',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                      controller: contactNum,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Contact No',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                      controller: email,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Email',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue2,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        onChanged: (String data) {
                          setState(() {
                            dropdownValue2 = data;
                          });
                        },
                        items: spinnerItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                        onChanged: (String data) {
                          setState(() {
                            dropdownValue = data;
                          });
                        },
                        items: spinnerItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
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
