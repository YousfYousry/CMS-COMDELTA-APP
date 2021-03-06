// import 'dart:html';

// import 'dart:convert';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';

// import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import 'package:smart_select/smart_select.dart';
import '../../public.dart';

class AddDevice extends StatefulWidget {
  final String title;
  final DeviceJason editDevice;

  AddDevice(this.title, this.editDevice);

  @override
  _AddDevice createState() => _AddDevice();
}

class _AddDevice extends State<AddDevice> {
  Snack saveSnack;
  bool errorClient = false, errorLocation = false;

  String clientValue = "";
  S2Choice<String> locationValue = S2Choice<String>(value: '', title: '');
  String heightValue = "Above 45m";
  String siteRegionValue = "";
  String simProvider = "";
  String batteryStatus = "Inactive";
  String rssiStatus = "Inactive";

  // DateTime initialDate = DateTime.now();

  TextEditingController quantity = TextEditingController()..text = "1",
      deviceName = new TextEditingController(),
      deviceDetail = new TextEditingController(),
      latitude = new TextEditingController(),
      longitude = new TextEditingController(),
      batchNum = new TextEditingController(),
      serialNum = new TextEditingController(),
      activationDate = new TextEditingController();

  bool loading = false;

  @override
  void initState() {
    if (widget.editDevice != null && widget.title.contains("Edit")) {
      setState(() {
        // clientValue = client[getInt(widget.editDevice.client) - 1].title;
        clientValue = widget.editDevice.getClient;
        locationValue = location
            .getRange(getSafeInt(widget.editDevice.deviceLocationId) - 1, getSafeInt(widget.editDevice.deviceLocationId))
            .first;
        heightValue = widget.editDevice.deviceHeight;
        siteRegionValue = widget.editDevice.siteRegion;
        simProvider = widget.editDevice.simProvider;
        batteryStatus = status[getInt(widget.editDevice.batteryStatus)].title;
        rssiStatus = status[getInt(widget.editDevice.rssiStatus)].title;
        activationDate.text = widget.editDevice.activationDate;
        deviceName.text = widget.editDevice.deviceName;
        deviceDetail.text = widget.editDevice.deviceDetails;
        latitude.text = widget.editDevice.lat == 500
            ? ""
            : widget.editDevice.lat.toString();
        longitude.text = widget.editDevice.lon == 500
            ? ""
            : widget.editDevice.lon.toString();
        batchNum.text = widget.editDevice.batchNum;
        serialNum.text = widget.editDevice.serialNum;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    saveSnack = new Snack(context, "Saving...", 100);
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
          child: CustomAppBarBack(context, widget.title),
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
                    Visibility(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Quantity',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                // children: [
                                //   TextSpan(
                                //     text: ' *',
                                //     style: TextStyle(
                                //         color: Colors.red, fontSize: 16.0),
                                //   ),
                                // ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            top: 18,
                                            bottom: 18,
                                            right: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      controller: quantity,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: false,
                                      ),
                                      inputFormatters: <TextInputFormatter>[],
                                    ),
                                  ),
                                  Container(
                                    height: 55.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              child: Icon(
                                                Icons.arrow_drop_up,
                                                size: 22.0,
                                              ),
                                              onTap: () {
                                                int currentValue =
                                                    int.parse(quantity.text);
                                                setState(() {
                                                  currentValue++;
                                                  quantity.text = (currentValue)
                                                      .toString(); // incrementing value
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              size: 22.0,
                                            ),
                                            onTap: () {
                                              int currentValue =
                                                  int.parse(quantity.text);
                                              setState(() {
                                                print("Setting state");
                                                currentValue--;
                                                quantity.text = (currentValue >
                                                            0
                                                        ? currentValue
                                                        : 1)
                                                    .toString(); // decrementing value
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      visible: widget.title.contains("Add"),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Client',
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
                    ModalFilter(
                        value: clientValue,
                        title: "Client",
                        options: client,
                        passVal: (val) => setState(() {
                              clientValue = val;
                              errorClient = false;
                            }),
                        errorText: 'Please enter Client',
                        disableCancel: true,
                        error: errorClient),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Location',
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
                    ModalFilter(
                        value: locationValue.title,
                        title: "Location",
                        options: location,
                        disableCancel: true,
                        passVal: (val) => setState(() {
                              int index = getInt(val);
                              locationValue = location
                                  .getRange(index - 1, index)
                                  .first;
                              errorLocation = false;
                            }),
                        errorText: 'Please enter Location',
                        error: errorLocation),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Device Name',
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
                      controller: deviceName,
                      title: 'Device Name',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Device Detail',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: deviceDetail,
                      title: 'Device Detail',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Latitude',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: latitude,
                      title: 'Latitude',
                      keyboardType: TextInputType.number,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Longitude',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: longitude,
                      title: 'Longitude',
                      keyboardType: TextInputType.number,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Height',
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
                    ModalFilter(
                      value: heightValue,
                      title: "Height",
                      options: height,
                      passVal: (val) => setState(() => heightValue = val),
                      initial: true,
                      initialValue: "Above 45m",
                      disableCancel: true,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Activation Date',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartDate(
                      controller: activationDate,
                      hintText: 'Activation Date',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Site Region',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: siteRegionValue,
                      title: "Site Region",
                      options: siteRegion,
                      passVal: (val) => setState(() => siteRegionValue = val),
                      disableCancel: true,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Client Batch Number',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: batchNum,
                      title: 'Client Batch Number',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Sim serial Number',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    SmartField(
                      controller: serialNum,
                      title: 'Sim serial Number',
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Sim Provider',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: simProvider,
                      title: "Sim Provider",
                      options: simCardProvider,
                      disableCancel: true,
                      passVal: (val) => setState(() => simProvider = val),
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Battery Status',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: batteryStatus,
                      title: "Battery Status",
                      options: status,
                      passVal: (val) => setState(() => batteryStatus = val),
                      initial: true,
                      initialValue: "Inactive",
                      disableCancel: true,
                    ),
                    // SizedBox(height: 20),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'RSSI Status',
                    //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    ModalFilter(
                      value: rssiStatus,
                      title: "RSSI Status",
                      options: status,
                      passVal: (val) => setState(() => rssiStatus = val),
                      initial: true,
                      initialValue: "Inactive",
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
    if (getInt(quantity.text) < 1) {
      toast("Please enter a valid Quantity");
      return;
    }

    if (clientValue.isEmpty) {
      setState(() {
        errorClient = true;
      });
    }

    if (locationValue.title.isEmpty) {
      setState(() {
        errorLocation = true;
      });
    }

    if (clientValue.isEmpty || locationValue.title.isEmpty) {
      toast("Please fill in all the required fields.");
      return;
    }

    saveSnack.show();
    load('user_id').then((value) =>
        value != '-1' ? postReq(value) : toast('User was not found!'));
  }

  void postReq(String userId) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/saveDevice.php'),
        body: {
          'add_edit':
              widget.title.toLowerCase().contains("add") ? "add" : "edit",
          'quantity': quantity.text,
          'device_id': widget.title.toLowerCase().contains("add")
              ? ""
              : widget.editDevice.id,
          'client': (client.indexOf(S2Choice<String>(
                      value: clientValue, title: clientValue)) +
                  1)
              .toString(),
          'location': (location.indexOf(locationValue) + 1).toString(),
          'device_name': deviceName.text,
          'device_detail': deviceDetail.text,
          'latitude': latitude.text,
          'longitude': longitude.text,
          'height': (height.indexOf(
                  S2Choice<String>(value: heightValue, title: heightValue)))
              .toString(),
          'activation_date': activationDate.text,
          'site_region': siteRegionValue,
          'batch_num': batchNum.text,
          'serial_num': serialNum.text,
          'sim_provider': simProvider,
          'battery_status': (status.indexOf(
                  S2Choice<String>(value: batteryStatus, title: batteryStatus)))
              .toString(),
          'rssi_status': (status.indexOf(
                  S2Choice<String>(value: rssiStatus, title: rssiStatus)))
              .toString(),
          'user_id': userId,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        if (body == '0') {
          toast("Device has been added successfully");
          Navigator.pop(this.context);
        } else if (body == '1') {
          toast("Couldn't create Id for the new device!");
        } else if (body == '2') {
          toast("Your email doesn't exist on the sever!");
        } else if (body == '3') {
          toast("Device was not found to edit!");
        } else if (body == '10') {
          toast("Device has been modified successfully");
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
