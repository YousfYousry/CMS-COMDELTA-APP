import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/public.dart';
import 'package:login_cms_comdelta/JasonHolders/ClientJason.dart';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
// import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';

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
  String oldClientName = "";
  final ClientJason client;

  _AddClient(this.title, this.client) {
    if (this.title == null || this.title.isEmpty) {
      this.title = "Add Client";
    } else if (this.client != null) {
      statTwo = (client.statTwo.contains("0")) ? "Hidden" : "Shown";
      statThree = (client.statThree.contains("0")) ? "Hidden" : "Shown";
      clientName.text = client.clientName;
      address.text = client.clientAddress;
      contactNum.text = client.clientContact;
      email.text = client.clientEmail;
      oldClientName = client.clientName;
    }
  }

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
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Client Name',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //     children: [
                    //       TextSpan(
                    //         text: ' *',
                    //         style: TextStyle(color: Colors.red, fontSize: 16.0),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: clientName,
                      onChanged: (text) {
                        if (validate && text.isNotEmpty) {
                          setState(() {
                            validate = false;
                          });
                        }
                      },
                      errorText: validate ? validateText : null,
                      title: 'Client Name',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Address',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: address,
                      title: 'Address',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Contact No',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: contactNum,
                      title: 'Contact No',
                      keyboardType: TextInputType.number,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Email',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: email,
                      title: 'Email',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Active Device Last 72 Hours\n(Dashboard)',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: statTwo,
                      title: "Active Device Last 72 Hours\n(Dashboard)",
                      options: clientStatus,
                      passVal: (val) => setState(()=> statTwo = val),
                      initial: true,
                      initialValue: "Hidden",
                      disableCancel: true,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Inactive Device Last 72 Hours\n(Dashboard)',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: statThree,
                      title: "Inactive Device Last 72 Hours\n(Dashboard)",
                      options: clientStatus,
                      passVal: (val) => setState(()=> statThree = val),
                      initial: true,
                      initialValue: "Hidden",
                      disableCancel: true,
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
            Center(
              child: Loading(
                loading: loading,
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
      toast("Please fill in the required field.");
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
