import 'package:login_cms_comdelta/Classes/deviceElement.dart';
import 'package:login_cms_comdelta/Widgets/CustomAppBarWithBack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'Widgets/CustomAppBar.dart';
// import 'Widgets/CustomeAppBar.dart';
import 'Widgets/DeviceElement.dart';
import 'Widgets/ProgressBar.dart';
// import 'Widgets/SideDrawer.dart';
import 'dart:math' as math;
import 'dart:convert';

const PrimaryColor = const Color(0xff0065a3);

class TotalDeviceCard extends StatelessWidget {
  // This widget is the root of your application.
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
      child: MaterialApp(
        title: 'Devices',
        theme: ThemeData(
          primaryColor: PrimaryColor,
        ),
        home: TotalDeviceCardPage(title: 'Total Devices'),
      ),
    );
  }
}

class TotalDeviceCardPage extends StatefulWidget {
  TotalDeviceCardPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TotalDeviceCard createState() => _TotalDeviceCard();
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
          )),
    );

class _TotalDeviceCard extends State<TotalDeviceCardPage> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true,validate=false;

  // ignore: deprecated_member_use
  var items = List<DeviceElement>();

  // ignore: deprecated_member_use
  var duplicateItems = List<DeviceElement>();

  var span1 = spanDown, span2 = spanDefault, span3 = spanDefault;

  void _sort1() {
    if (span1 != spanDown) {
      items.sort((a, b) => getDouble(a.getId()).compareTo(getDouble(b.getId())));
      span1 = spanDown;
    } else {
      items.sort((a, b) => getDouble(b.getId()).compareTo(getDouble(a.getId())));
      span1 = spanUp;
    }
    span2 = spanDefault;
    span3 = spanDefault;
  }

  void _sort2() {
    if (span2 != spanDown) {
      items.sort((a, b) => a.getDeviceDetail().compareTo(b.getDeviceDetail()));
      span2 = spanDown;
    } else {
      items.sort((a, b) => b.getDeviceDetail().compareTo(a.getDeviceDetail()));
      span2 = spanUp;
    }
    span1 = spanDefault;
    span3 = spanDefault;
  }

  void _sort3() {
    if (span3 != spanDown) {
      items.sort((a, b) => a.getLocation().compareTo(b.getLocation()));
      span3 = spanDown;
    } else {
      items.sort((a, b) => b.getLocation().compareTo(a.getLocation()));
      span3 = spanUp;
    }
    span2 = spanDefault;
    span1 = spanDefault;
  }

  @override
  void initState() {
    getDevices();
    super.initState();
  }

//  someObjects.sort((a, b) => a.someProperty.compareTo(b.someProperty));

  void filterSearchResults(String query) {
    bool resultFound=false;
    // ignore: deprecated_member_use
    var dummySearchList = List<DeviceElement>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      // ignore: deprecated_member_use
      var dummyListData = List<DeviceElement>();
      dummySearchList.forEach((item) {
        if (item.getId().toLowerCase().contains(query.toLowerCase()) ||
            item
                .getDeviceDetail()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item.getLocation().toLowerCase().contains(query.toLowerCase())) {
          resultFound=true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        validate = false;
        span1 = spanDown;
        span2 = spanDefault;
        span3 = spanDefault;
        items.clear();
        items.addAll(duplicateItems);
        items.forEach((item) => item.setHighLight(''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBarBack(context,'Total Devices'),
          preferredSize: const Size.fromHeight(50),
        ),
        // drawer: SideDrawer(),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (text) {
                      filterSearchResults(text);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(20.0),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
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
                      children: [
                        Container(
                          height: 30,
                          color: Colors.grey[200],
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort1();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'ID'),
                                          span1,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 4,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort2();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Device Detail'),
                                          span2,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 2,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort3();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Location'),
                                          span3,
                                        ],
                                      ),
                                    ),
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
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listItem(
                                  context: context,
                                  index: index,
                                  ID: items[index].getId(),
                                  Details: items[index].getDeviceDetail(),
                                  Location: items[index].getLocation(),
                                  HighLight: items[index].getHighLight());
                            },
                          ),

                          // child: ListView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: items.length,
                          //   itemBuilder: (context, index) {
                          //     return ListTile(
                          //       title: Text('${items[index]}'),
                          //     );
                          //   },
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Visibility(
                child: CircularProgressIndicatorApp(),
                visible: loading,
              ),
            ),
          ],
        ));
  }

  Future<void> getDevices() async {
    load('client_id').then((value) =>
        value != '-1' ? sendGet(value) : toast('User was not found!'));
  }

  void sendGet(String clientId) {
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/getLocations.php'))
        .then((value) {
      // ignore: deprecated_member_use
      List<String> id = new List<String>();
      // ignore: deprecated_member_use
      List<String> locationName = new List<String>();
      if (value.statusCode == 200) {
        // ignore: deprecated_member_use
        List<dynamic> values = new List<dynamic>();
        values = json.decode(value.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              id.add(map['location_id'].toString());
              locationName.add(map['location_name'].toString());
            }
          }
        }
        sendPost(clientId, id, locationName);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void sendPost(String clientId, List<String> id, List<String> locationName) {
    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/getDevice.php'),
        body: {
          'client_id': clientId,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        List<DeviceElement> devices = new List<DeviceElement>();
        // ignore: deprecated_member_use
        List<dynamic> values = new List<dynamic>();
        values = json.decode(response.body);
        // print(values);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              devices.add(DeviceElement.fromJson(
                  map, (i + 1).toString(), id, locationName));
            }
          }
        }
        showDevices(devices);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showDevices(List<DeviceElement> devices) {
    setState(() {
      duplicateItems.addAll(devices);
      items.addAll(devices);
      loading = false;
    });
  }

  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '-1';
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 0;
    }
  }
}
