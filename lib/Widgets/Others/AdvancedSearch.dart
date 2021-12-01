import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDateHor.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextFieldHor.dart';
import '../../public.dart';

class AdvancedSearch {
  final context;
  final getLocations;
  TextEditingController searchController;
  bool advancedSearchBool = false;
  bool startIdError = false;
  bool endIdError = false;
  String clientAd = "", simProviderAd = "", deviceStatusAd = "";
  TextEditingController batchNumAd = new TextEditingController(),
      deviceDetailsAd = new TextEditingController(),
      activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      lastSignalFromAd = new TextEditingController(),
      lastSignalToAd = new TextEditingController(),
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
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(this.context),
                  ),
                  backgroundColor: Color(0xff0065a3),
                  title: const Text('Advanced Search'),
                  actions: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.white),
                        textTheme: TextTheme().apply(bodyColor: Colors.white),
                      ),
                      child: PopupMenuButton<int>(
                        color: Color(0xff0065a3),
                        onSelected: (item) {
                          setState(() {
                            reset();
                          });
                          if (item == 1) {
                            advancedSearchBool = false;
                            getLocations();
                            Navigator.pop(this.context);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(Icons.clear),
                                const SizedBox(width: 8),
                                Text('Clear all fields'),
                              ],
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(Icons.library_add_check_outlined),
                                const SizedBox(width: 8),
                                Text('All Devices'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.restart_alt,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {
                    //     // clientAd = "";
                    //     // simProviderAd = "";
                    //     // batchNumAd.text = "";
                    //     // activationFromAd.text = "";
                    //     // activationToAd.text = "";
                    //     // lastSignalAd.text = "";
                    //     // searchController.text = "";
                    //     // startingId.text = "";
                    //     // endingId.text = "";
                    //     // startIdError = false;
                    //     // endIdError = false;
                    //     reset();
                    //     Navigator.pop(this.context);
                    //     // getLocations();
                    //   },
                    // )
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
                          ModalFilter(
                            value: clientAd,
                            title: "Client",
                            options: client,
                            passVal: (val) => setState(() => clientAd = val),
                          ),
                          ModalFilter(
                            value: simProviderAd,
                            title: "Sim Provider",
                            options: simCardProvider,
                            passVal: (val) =>
                                setState(() => simProviderAd = val),
                          ),
                          ModalFilter(
                            value: deviceStatusAd,
                            title: "Device Status",
                            options: deviceStatus,
                            passVal: (val) =>
                                setState(() => deviceStatusAd = val),
                            initial: true,
                            initialValue: "All Devices",
                          ),

                          SmartField(
                            controller: deviceDetailsAd,
                            title: "Device Detail",
                          ),

                          SmartField(
                            controller: batchNumAd,
                            title: "Client Batch Number",
                          ),

                          SmartDateH(
                            controller: activationFromAd,
                            controller2: activationToAd,
                            title: "Activation (Date)",
                            hintText: "From",
                            hintText2: "To",
                          ),

                          SmartDateH(
                            controller: lastSignalFromAd,
                            controller2: lastSignalToAd,
                            title: "Last Signal (Date)",
                            hintText: "From",
                            hintText2: "To",
                          ),

                          SmartFieldH(
                            controller: startingId,
                            title: "ID",
                            hint1: "From",
                            hint2: "To",
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
                            controller2: endingId,
                            keyboardType2: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            errorText2: endIdError
                                ? "Please enter integer value"
                                : null,
                            onChanged2: (value) {
                              if (isInt(value)) {
                                setState(() {
                                  endIdError = false;
                                });
                              }
                            },
                          ),

                          // SmartDate(
                          //   controller: lastSignalAd,
                          //   hintText: "Last Signal From",
                          // ),

                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (allEmpty()) {
                      toast("Please fill in any field to search");
                      return;
                    }
                    setState(() => errorSetters());
                    if (hasError()) return;
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

  void errorSetters() {
    startIdError = startingId.text.isNotEmpty && !isInt(startingId.text);
    endIdError = endingId.text.isNotEmpty && !isInt(endingId.text);
  }

  bool hasError() {
    if (startIdError || endIdError) {
      toast("Please enter integer value");
      return true;
    } else {
      return false;
    }
  }

  bool allEmpty() {
    return clientAd == "" &&
        simProviderAd == "" &&
        deviceStatusAd == "" &&
        deviceDetailsAd.text == "" &&
        batchNumAd.text == "" &&
        activationFromAd.text == "" &&
        activationToAd.text == "" &&
        lastSignalFromAd.text == "" &&
        lastSignalToAd.text == "" &&
        startingId.text == "" &&
        endingId.text == "";
  }

  void reset() {
    clientAd = "";
    simProviderAd = "";
    deviceStatusAd = "";
    deviceDetailsAd.text = "";
    batchNumAd.text = "";
    activationFromAd.text = "";
    activationToAd.text = "";
    lastSignalFromAd.text = "";
    lastSignalToAd.text = "";
    searchController.text = "";
    startingId.text = "";
    endingId.text = "";
    startIdError = false;
    endIdError = false;
  }

  bool filterDevice(DeviceJason device) {
    if (advancedSearchBool) {
      bool clientBool = (clientAd.isEmpty ||
          client[getInt(device.client) - 1].contains(clientAd));

      bool statusBool = deviceStatusAd.isEmpty || (deviceStatusAd.toLowerCase().contains("inactive")?device.inActiveLast72():!device.inActiveLast72());

      bool batchBool = (batchNumAd.text.isEmpty ||
          device.batchNum.toLowerCase().contains(batchNumAd.text.toString()));
      bool detailsBool = (deviceDetailsAd.text.isEmpty ||
          device.deviceDetails.toLowerCase().contains(deviceDetailsAd.text.toString()));


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



      bool lastSignalFromBool;
      try {
        lastSignalFromBool = (lastSignalFromAd.text.isEmpty ||
            DateFormat('yyyy-MM-dd HH:mm:ss').parse(device.lastSignal).isAfter(
                DateFormat('dd-MM-yyyy').parse(lastSignalFromAd.text)) ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAtSameMomentAs(
                DateFormat('dd-MM-yyyy').parse(lastSignalFromAd.text)));
      } catch (Exception) {
        lastSignalFromBool = false;
      }
      bool lastSignalToBool;
      try {
        lastSignalToBool = (lastSignalToAd.text.isEmpty ||
            DateFormat('yyyy-MM-dd HH:mm:ss').parse(device.lastSignal).isBefore(
                DateFormat('dd-MM-yyyy').parse(lastSignalToAd.text)) ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAtSameMomentAs(
                DateFormat('dd-MM-yyyy').parse(lastSignalToAd.text)));
      } catch (Exception) {
        lastSignalToBool = false;
      }

      bool simBool =
          (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));

      // bool lastSignalBool;
      // try {
      //   lastSignalBool = (lastSignalAd.text.isEmpty ||
      //       DateFormat('yyyy-MM-dd HH:mm:ss')
      //           .parse(device.lastSignal)
      //           .isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)) ||
      //       DateFormat('yyyy-MM-dd HH:mm:ss')
      //           .parse(device.lastSignal)
      //           .isAtSameMomentAs(
      //               DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));
      // } catch (Exception) {
      //   lastSignalBool = false;
      // }

      bool startIdBool = startingId.text.isEmpty ||
          getInt(device.id) >= getInt(startingId.text);
      bool endIdBool =
          endingId.text.isEmpty || getInt(device.id) <= getInt(endingId.text);

      if (clientBool &&
          batchBool &&
          detailsBool &&
          statusBool &&
          activationFromBool &&
          activationToBool &&
          simBool &&
          lastSignalFromBool &&
          lastSignalToBool &&
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
