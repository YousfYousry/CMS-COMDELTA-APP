// import 'dart:html';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:login_cms_comdelta/Pages/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';

import 'package:login_cms_comdelta/Widgets/Others/smartSelect.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';

import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
// import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import '../../Choices.dart';

// import 'package:smart_select/smart_select.dart';

String title = "Add Device";

class AddDevice extends StatefulWidget {
  AddDevice({title});

  @override
  _AddDevice createState() => _AddDevice();
}

class _AddDevice extends State<AddDevice> {
  Snack saveSnack;

  String clientValue = "Select option";
  String locationValue = "Select option";
  String heightValue = "Above 45m";
  String siteRegionValue = "Select option";
  String simProvider = "Select option";
  String batteryStatus = "Inactive";
  String rSSIStatus = "Inactive";
  DateTime initialDate = DateTime.now();

  TextEditingController deviceName = new TextEditingController(),
      deviceDetail = new TextEditingController(),
      latitude = new TextEditingController(),
      longitude = new TextEditingController(),
      batchNum = new TextEditingController(),
      serialNum = new TextEditingController(),
      activationDate = new TextEditingController();

  bool loading = !title.contains("Add");

  @override
  Widget build(BuildContext context) {
    saveSnack = new Snack(context,"Saving...",100);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
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
                        text: 'Client',
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
                    ModalFilter(clientValue, "Client", client,
                        (val) => clientValue = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Location',
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
                    ModalFilter(locationValue, "Location", location,
                        (val) => locationValue = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Device Name',
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
                      controller: deviceName,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Device Name',
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
                        text: 'Device Detail',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      controller: deviceDetail,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Device Detail',
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
                        text: 'Latitude',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      controller: latitude,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Latitude',
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
                        text: 'Longitude',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      controller: longitude,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Longitude',
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
                        text: 'Height',
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
                    ModalFilter(heightValue, "Height", height,
                        (val) => heightValue = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Activation Date',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onTap: () => _selectDate(context),
                        child: TextField(
                          controller: activationDate,
                          enabled: false,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: 'Activation Date',
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            contentPadding: EdgeInsets.only(
                                left: 15, top: 19, bottom: 19, right: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Site Region',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(siteRegionValue, "Site Region", siteRegion,
                        (val) => siteRegionValue = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Client Batch Number',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      controller: batchNum,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Client Batch Number',
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
                        text: 'Sim serial Number',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      controller: serialNum,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Sim serial Number',
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
                        text: 'Site Region',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(simProvider, "Sim Provider", simCardProvider,
                        (val) => simProvider = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'Battery Status',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(batteryStatus, "Battery Status", status,
                        (val) => batteryStatus = val),
                    SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        text: 'RSSI Status',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(rSSIStatus, "RSSI Status", status,
                        (val) => rSSIStatus = val),
                    SizedBox(height: 20),

                    // Material(
                    //   color: Colors.white,
                    //   child: InkWell(
                    //     customBorder: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //     //
                    //     child: Container(
                    //       // padding: EdgeInsets.symmetric(vertical: 10.0),
                    //       decoration: ShapeDecoration(
                    //         shape: RoundedRectangleBorder(
                    //           side: BorderSide(
                    //               width: 1.0,
                    //               style: BorderStyle.solid,
                    //               color: Colors.grey),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10.0)),
                    //         ),
                    //       ),
                    //       child: SmartSelect<String>.single(
                    //         title: value,
                    //         value: value,
                    //         onChange: (state) =>
                    //             setState(() => value = state.value),
                    //         choiceItems: options,
                    //         modalTitle: "Site Region",
                    //         modalConfirm: false,
                    //         modalType: S2ModalType.popupDialog,
                    //         modalConfig: S2ModalConfig(
                    //           style: S2ModalStyle(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(10.0)),
                    //             ),
                    //           ),
                    //         ),
                    //         choiceGrouped: false,
                    //         modalFilter: true,
                    //         modalFilterAuto: true,
                    //         tileBuilder: (context, state) {
                    //           return S2Tile.fromState(
                    //             state,
                    //             hideValue: true,
                    //           );
                    //         },
                    //       ),
                    //     ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(0xff0065a3, customColors),
              primaryColorDark: Color(0xff0065a3),
              accentColor: Color(0xff0065a3),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    if (pickedDate != null && pickedDate != initialDate)
      setState(() {
        initialDate = pickedDate;
        activationDate.text = formatDate(pickedDate);
        // toast(formatDate(pickedDate));
      });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void save() {
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
            'http://103.18.247.174:8080/AmitProject/admin/saveDevice.php'),
        body: {


        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
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
        }else {
          toast("Something wrong with the server");
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
