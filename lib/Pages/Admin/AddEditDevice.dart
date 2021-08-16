// import 'dart:html';

// import 'dart:convert';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import 'package:smart_select/smart_select.dart';
import '../../Choices.dart';

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
  String locationValue = "";
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
        clientValue = client[getInt(widget.editDevice.client) - 1].title;
        locationValue = widget.editDevice.deviceLocation;
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
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0),
                                  ),
                                ],
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
                    ModalFilter(clientValue, "Client", client, (val) {
                      clientValue = val;
                      setState(() => errorClient = false);
                    }, 'Please enter Client', errorClient),
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
                    ModalFilter(locationValue, "Location", location, (val) {
                      locationValue = val;
                      setState(() => errorLocation = false);
                    }, 'Please enter Location', errorLocation),
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
                    SmartField(
                      controller: deviceName,
                      hintText: 'Device Name',
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Device Detail',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartField(
                      controller: deviceDetail,
                      hintText: 'Device Detail',
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Latitude',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartField(
                      controller: latitude,
                      hintText: 'Latitude',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Longitude',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartField(
                      controller: longitude,
                      hintText: 'Longitude',
                      keyboardType: TextInputType.number,
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
                        (val) => heightValue = val, '', false),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Activation Date',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartDate(
                      controller: activationDate,
                      hintText: 'Activation Date',
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
                        (val) => siteRegionValue = val, '', false),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Client Batch Number',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartField(
                      controller: batchNum,
                      hintText: 'Client Batch Number',
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Sim serial Number',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    SmartField(
                      controller: serialNum,
                      hintText: 'Sim serial Number',
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Sim Provider',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(simProvider, "Sim Provider", simCardProvider,
                        (val) => simProvider = val, '', false),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Battery Status',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(batteryStatus, "Battery Status", status,
                        (val) => batteryStatus = val, '', false),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'RSSI Status',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    ModalFilter(rssiStatus, "RSSI Status", status,
                        (val) => rssiStatus = val, '', false),
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

    if (locationValue.isEmpty) {
      setState(() {
        errorLocation = true;
      });
    }

    if (clientValue.isEmpty || locationValue.isEmpty) {
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
          'location': (location.indexOf(S2Choice<String>(
                      value: locationValue, title: locationValue)) +
                  1)
              .toString(),
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

  int getInt(String s) {
    try {
      if (s == null || int.parse(s) == null) {
        return 0;
      }
      return int.parse(s);
    } catch (Exception) {
      return 0;
    }
  }
}
