import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Choices.dart';
import 'package:login_cms_comdelta/JasonHolders/ClientJason.dart';
import 'package:http/http.dart' as http;
// import 'package:login_cms_comdelta/Pages/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
// import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

class AddClient extends StatefulWidget {
  final String title;
  final ClientJason client;

  AddClient({this.title, this.client});

  @override
  _AddClient createState() => _AddClient(title, client);
}

class _AddClient extends State<AddClient> {
  String validateText = "";
  bool validate = false;
  Snack saveSnack;
  String statTwo = "Hidden";
  String statThree = "Hidden";
  TextEditingController clientName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController email = TextEditingController();
  String title;
  String oldClientName="";
  final ClientJason client;

  _AddClient(this.title, this.client) {
    if (this.title == null || this.title.isEmpty) {
      this.title = "Add Client";
    } else if (this.client != null) {
      statTwo = (client.statTwo.contains("0")) ? "Shown" : "Hidden";
      statThree = (client.statThree.contains("0")) ? "Shown" : "Hidden";
      clientName.text = client.clientName;
      address.text = client.clientAddress;
      contactNum.text = client.clientContact;
      email.text = client.clientEmail;
      oldClientName = client.clientName;
    }
  }

  // bool loading = !title.contains("Add");
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    saveSnack = new Snack(context, "Saving...", 100);

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
          onPressed: () => save(),
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
                      onChanged: (text) {
                        if (validate && text.isNotEmpty) {
                          setState(() {
                            validate = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        errorText: validate ? validateText : null,
                        hintText: 'Client Name',
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 19, bottom: 19, right: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
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
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 19, bottom: 19, right: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
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
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 19, bottom: 19, right: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
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
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 19, bottom: 19, right: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
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
                    ModalFilter(statTwo, "Active Device", clientStatus,
                        (val) => statTwo = val,'',false),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   decoration: ShapeDecoration(
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       side:
                    //           BorderSide(width: 1.0, style: BorderStyle.solid),
                    //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //     ),
                    //   ),
                    //   child: DropdownButton<String>(
                    //     value: dropdownValue2,
                    //     isExpanded: true,
                    //     icon: Icon(Icons.arrow_drop_down),
                    //     iconSize: 24,
                    //     elevation: 16,
                    //     style: TextStyle(color: Colors.black, fontSize: 14),
                    //     underline: Container(
                    //       height: 0,
                    //       color: Colors.transparent,
                    //     ),
                    //     onChanged: (String data) {
                    //       setState(() {
                    //         dropdownValue2 = data;
                    //       });
                    //     },
                    //     items: spinnerItems
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Inactive Device Last 72 Hours\n(Dashboard)',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(statThree, "Inactive Device", clientStatus,
                        (val) => statThree = val,'',false),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   decoration: ShapeDecoration(
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       side:
                    //           BorderSide(width: 1.0, style: BorderStyle.solid),
                    //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //     ),
                    //   ),
                    //   child: DropdownButton<String>(
                    //     value: dropdownValue,
                    //     isExpanded: true,
                    //     icon: Icon(Icons.arrow_drop_down),
                    //     iconSize: 24,
                    //     elevation: 16,
                    //     style: TextStyle(color: Colors.black, fontSize: 14),
                    //     underline: Container(
                    //       height: 0,
                    //       color: Colors.transparent,
                    //     ),
                    //     onChanged: (String data) {
                    //       setState(() {
                    //         dropdownValue = data;
                    //       });
                    //     },
                    //     items: spinnerItems
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    SizedBox(height: 100),
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

  void save() {
    //check if name is written
    //done then from server check if no name is found

    if (clientName.text.isNotEmpty) {
      saveSnack.show();
      load('user_id').then((value) =>
          value != '-1' ? postReq(value) : toast('User was not found!'));
    } else {
      setState(() {
        validateText = "Client Name is required";
        validate = true;
      });
    }
  }

  void postReq(String userId) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/saveClient.php'),
        body: {
          'add_edit': this.title.toLowerCase().contains("add") ? "add" : "edit",
          'client_name': oldClientName,
          'new_client_name': clientName.text,
          'address': address.text,
          'contact_no': contactNum.text,
          'email': email.text,
          'active': statTwo.toLowerCase().contains("hidden") ? "1" : "0",
          'inactive': statThree.toLowerCase().contains("hidden") ? "1" : "0",
          'user_id': userId,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        print(body);
        if (body == '0') {
          toast("Client has been added successfully");
          Navigator.pop(this.context);
        } else if (body == '1') {
          // toast("Client Name already exist!");
          setState(() {
            validateText = "Client Name already exist!";
            validate = true;
          });
        } else if (body == '2') {
          toast("Your email doesn't exist on the sever!");
        } else if (body == '3') {
          toast("Client was not found to edit!");
        } else if (body == '10') {
          toast("Client has been modified successfully");
          Navigator.pop(this.context);
        } else {
          toast("Something wrong with the server!");
          print(body);
        }
        saveSnack.hide();
      } else {
        print(response.body);
        saveSnack.hide();
      }
    }).onError((error, stackTrace) {
      toast('Error: ' + error.message);
      saveSnack.hide();
    });
  }
}
