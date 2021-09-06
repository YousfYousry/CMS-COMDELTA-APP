import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';

import '../../Choices.dart';

class AdvancedSearch {
  final context;
  final getLocations;
  TextEditingController searchController;

  bool advancedSearchBool = false;
  bool startIdError = false;
  bool endIdError = false;
  String clientAd = "", simProviderAd = "";
  TextEditingController batchNumAd = new TextEditingController(),
      activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      lastSignalAd = new TextEditingController(),
      startingId = new TextEditingController(),
      endingId = new TextEditingController();

  AdvancedSearch(this.context, this.getLocations, this.searchController);

  void show() {
    Navigator.of(context).push(
      new MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return new Scaffold(
                backgroundColor: Color(0xfafafafa),
                appBar: new AppBar(
                  centerTitle: true,
                  backgroundColor: Color(0xff0065a3),
                  title: const Text('Advanced Search'),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.restart_alt,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // clientAd = "";
                        // simProviderAd = "";
                        // batchNumAd.text = "";
                        // activationFromAd.text = "";
                        // activationToAd.text = "";
                        // lastSignalAd.text = "";
                        // searchController.text = "";
                        // startingId.text = "";
                        // endingId.text = "";
                        // startIdError = false;
                        // endIdError = false;
                        reset();
                        Navigator.pop(this.context);
                        // getLocations();
                      },
                    )
                  ],
                ),
                body: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(15),
                      color: Color(0xfafafafa),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ModalFilter(clientAd, "Client", client,
                              (val) => clientAd = val, "", false),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Client Batch Number',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartField(
                            controller: batchNumAd,
                            hintText: "Client Batch Number",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Activation Date From',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartDate(
                            controller: activationFromAd,
                            hintText: "Activation Date From",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Activation Date To',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartDate(
                            controller: activationToAd,
                            hintText: "Activation Date To",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Sim Provider',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ModalFilter(
                              simProviderAd,
                              "Sim Provider",
                              simCardProvider,
                              (val) => simProviderAd = val,
                              "",
                              false),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Last Signal From',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartDate(
                            controller: lastSignalAd,
                            hintText: "Last Signal From",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Starting Id',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartField(
                            controller: startingId,
                            hintText: "Starting Id",
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            errorText: startIdError
                                ? "Please enter integer value"
                                : null,
                            onChanged: (value) {
                              if (isInt(value)) {
                                setState(() {
                                  startIdError = false;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Ending Id',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SmartField(
                            controller: endingId,
                            hintText: "Ending Id",
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            errorText: endIdError
                                ? "Please enter integer value"
                                : null,
                            onChanged: (value) {
                              if (isInt(value)) {
                                setState(() {
                                  endIdError = false;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (clientAd == "" &&
                        simProviderAd == "" &&
                        batchNumAd.text == "" &&
                        activationFromAd.text == "" &&
                        activationToAd.text == "" &&
                        lastSignalAd.text == "" &&
                        startingId.text == "" &&
                        endingId.text == "") {
                      toast("Please fill in any field to search");
                      return;
                    }

                    setState(() {
                      startIdError =
                          startingId.text.isNotEmpty && !isInt(startingId.text);
                      endIdError =
                          endingId.text.isNotEmpty && !isInt(endingId.text);
                    });

                    if (startIdError || endIdError) {
                      toast("Please enter integer value");
                      return;
                    }
                    advancedSearchBool = true;
                    Navigator.pop(this.context);
                    getLocations();
                  },
                  child: const Icon(Icons.search),
                  backgroundColor: Color(0xff0065a3),
                ),
              );
            });
          },
          fullscreenDialog: true),
    );
  }

  bool filterDevice(DeviceJason device) {
    if (advancedSearchBool) {
      bool clientBool = (clientAd.isEmpty ||
          client[getInt(device.client) - 1].contains(clientAd));
      bool batchBool = (batchNumAd.text.isEmpty ||
          device.batchNum.toLowerCase().contains(batchNumAd.text.toString()));
      bool activationFromBool;
      try {
        activationFromBool = (activationFromAd.text.isEmpty ||
            DateFormat('dd-MM-yyyy').parse(device.activationDate).isAfter(
                DateFormat('dd-MM-yyyy').parse(activationFromAd.text)) ||
            DateFormat('dd-MM-yyyy')
                .parse(device.activationDate)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
      } catch (Exception) {
        activationFromBool = false;
      }
      bool activationToBool;
      try {
        activationToBool = (activationToAd.text.isEmpty ||
            DateFormat('dd-MM-yyyy').parse(device.activationDate).isBefore(
                DateFormat('dd-MM-yyyy').parse(activationToAd.text)) ||
            DateFormat('dd-MM-yyyy')
                .parse(device.activationDate)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(activationToAd.text)));
      } catch (Exception) {
        activationToBool = false;
      }
      bool simBool =
          (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));

      bool lastSignalBool;
      try {
        lastSignalBool = (lastSignalAd.text.isEmpty ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)) ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));
      } catch (Exception) {
        lastSignalBool = false;
      }

      bool startIdBool = startingId.text.isEmpty ||
          getInt(device.id) >= getInt(startingId.text);
      bool endIdBool =
          endingId.text.isEmpty || getInt(device.id) <= getInt(endingId.text);

      if (clientBool &&
          batchBool &&
          activationFromBool &&
          activationToBool &&
          simBool &&
          lastSignalBool &&
          startIdBool &&
          endIdBool) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void reset() {
    clientAd = "";
    simProviderAd = "";
    batchNumAd.text = "";
    activationFromAd.text = "";
    activationToAd.text = "";
    lastSignalAd.text = "";
    searchController.text = "";
    startingId.text = "";
    endingId.text = "";
    startIdError = false;
    endIdError = false;
    getLocations();
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

  bool isInt(String s) {
    try {
      if (s == null || int.parse(s) == null) {
        return false;
      }
      return true;
    } catch (Exception) {
      return false;
    }
  }
}
