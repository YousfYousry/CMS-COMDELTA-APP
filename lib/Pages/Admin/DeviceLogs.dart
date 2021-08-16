import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DeviceLogsAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'dart:math' as math;
import 'package:substring_highlight/substring_highlight.dart';

const PrimaryColor = const Color(0xff0065a3);

class DeviceLogs extends StatefulWidget {
  final device;

  DeviceLogs(this.device);

  @override
  _DeviceLogs createState() => _DeviceLogs();
}

var spanUp = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortup.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDown = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortdown.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDefault = WidgetSpan(
      child: Transform.rotate(
        angle: 90 * math.pi / 180,
        child: Icon(
          Icons.sync_alt,
          size: 15,
          color: Colors.grey,
        ),
      ),
    );

class _DeviceLogs extends State<DeviceLogs> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;

  var spans = [
    spanUp,
    spanDefault,
    spanDefault,
    spanDefault,
    spanDefault,
    spanDefault,
    spanDefault,
    spanDefault,
    spanDefault
  ];

  var logs = [];
  var duplicateLogs = [];

  LinkedScrollControllerGroup _controllers;
  ScrollController _letters;
  ScrollController _numbers;

  Widget titleElement(double width, double height, String title, int index) {
    return Container(
      width: width,
      height: height,
      child: InkWell(
        onTap: () {
          setState(() {
            bool isUp = (spans[index] != spanDown);
            resetSpans(isUp, index);
            spans[index] = isUp ? spanDown : spanUp;
          });
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: title),
                  spans[index],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget value(
      double height, double width, String title, String high, bool border) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: border ? 1.0 : 0, color: Colors.grey),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SubstringHighlight(
          text: title,
          term: high,
          textStyleHighlight: TextStyle(
            fontSize: 13,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textStyle: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget valueBulb(double height, double width, String title, bool border) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: border ? 1.0 : 0, color: Colors.grey),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.lightbulb_outline,
          color: title.contains("1") ? Colors.green : Colors.red,
          size: 20.0,
        ),
      ),
    );
  }

  void resetSpans(bool isUp, int index) {
    this.logs.sort((a, b) => isUp
        ? a.getE(index).compareTo(b.getE(index))
        : b.getE(index).compareTo(a.getE(index)));
    for (int i = 0; i < spans.length; i++) {
      spans[i] = spanDefault;
    }
  }

  void filterSearchResults(String query) {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateLogs);
    if (query.isNotEmpty) {
      var dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.isFound(query)) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        logs.clear();
        logs.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        validate = false;
        logs.clear();
        logs.addAll(duplicateLogs);
        logs.forEach((item) => item.setHighLight(''));
      });
    }
  }

  @override
  void initState() {
    getLogs();
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
  }

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
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: DeviceLogsAppBar(context, "Device Logs", showDeviceDetails),
          preferredSize: const Size.fromHeight(50),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (text) => filterSearchResults(text),
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(20.0),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleElement(130, 30, "Detail", 0),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _letters,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      titleElement(70, 30, "L1#", 1),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L1@", 2),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L2#", 3),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L2@", 4),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L3#", 5),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L3@", 6),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(80, 30, "Battery", 7),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "Rssi", 8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 131,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: logs.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey),
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey),
                                            ),
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color(0xf1f1f1f1),
                                          ),
                                          height: 30,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SubstringHighlight(
                                              text: logs[index].createDate,
                                              term: logs[index].highLight,
                                              textStyleHighlight: TextStyle(
                                                fontSize: 13,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      controller: _numbers,
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: 577,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: logs.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.grey),
                                                ),
                                                color: (index % 2 == 0)
                                                    ? Colors.white
                                                    : Color(0xf1f1f1f1),
                                              ),
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  value(
                                                      30,
                                                      71,
                                                      logs[index].lid1,
                                                      logs[index].highLight,
                                                      true),
                                                  valueBulb(30, 71,
                                                      logs[index].ls1, true),
                                                  value(
                                                      30,
                                                      71,
                                                      logs[index].lid2,
                                                      logs[index].highLight,
                                                      true),
                                                  valueBulb(30, 71,
                                                      logs[index].ls2, true),
                                                  value(
                                                      30,
                                                      71,
                                                      logs[index].lid3,
                                                      logs[index].highLight,
                                                      true),
                                                  valueBulb(30, 71,
                                                      logs[index].ls3, true),
                                                  value(
                                                      30,
                                                      81,
                                                      logs[index].batteryValue,
                                                      logs[index].highLight,
                                                      true),
                                                  value(
                                                      30,
                                                      70,
                                                      logs[index].rssiValue,
                                                      logs[index].highLight,
                                                      false),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  void getLogs() {
    setState(() {
      loading = true;
    });
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
        body: {
          'device_id': widget.device.id,
        }).then((value) {
      if (value.statusCode == 200) {
        List<LogJason> logs = [];
        List<dynamic> values = [];
        values = json.decode(value.body);

        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              logs.add(LogJason.fromJson(map));
            }
          }
        }
        showLogs(logs);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get Log list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showLogs(List<LogJason> logs) {
    logs.sort((a, b) => b.createDate.compareTo(a.createDate));
    setState(() {
      this.duplicateLogs.clear();
      this.logs.clear();
      this.logs.addAll(logs);
      this.duplicateLogs.addAll(logs);
      loading = false;
    });
  }

  void showDeviceDetails() {
    ShowDevice(context, widget.device);
  }
}
