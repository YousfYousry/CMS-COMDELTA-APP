import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/Cards/ShowDevice.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../public.dart';
import '../../Widgets/AppBars/CustomAppBarWithBack.dart';
import 'dart:math' as math;

enum Span { def, up, down }

class SpanUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2, bottom: 2),
      child: ImageIcon(
        AssetImage('assets/image/sortup.png'),
        size: 12,
        color: Colors.black,
      ),
    );
  }
}

class SpanDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2, bottom: 2),
      child: ImageIcon(
        AssetImage('assets/image/sortdown.png'),
        size: 12,
        color: Colors.black,
      ),
    );
  }
}

class SpanDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 90 * math.pi / 180,
      child: Icon(
        Icons.sync_alt,
        size: 15,
        color: Colors.grey,
      ),
    );
  }
}

class InactiveDeviceCard extends StatefulWidget {
  InactiveDeviceCard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InactiveDeviceCard createState() => _InactiveDeviceCard();
}

class _InactiveDeviceCard extends State<InactiveDeviceCard> {
  TextEditingController searchController = new TextEditingController();
  bool loading = false, validate = false;
  String resNum = "0";
  int sortState = 1;
  final PagingController<int, DeviceJason> _pagingController =
  PagingController(firstPageKey: 0);
  var duplicateDevices = [];

  var spans = [Span.up, Span.def, Span.def];

  Future<void> _sort1() async {
    if (spans[0] != Span.down) {
      sortState = 0;
      _pagingController.itemList
          .sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      spans[0] = Span.down;
    } else {
      sortState = 1;
      _pagingController.itemList
          .sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      spans[0] = Span.up;
    }
    spans[1] = Span.def;
    spans[2] = Span.def;
  }

  Future<void> _sort2() async {
    if (spans[1] != Span.down) {
      sortState = 2;
      _pagingController.itemList
          .sort((a, b) => a.deviceName.compareTo(b.deviceName));
      spans[1] = Span.down;
    } else {
      sortState = 3;
      _pagingController.itemList
          .sort((a, b) => b.deviceName.compareTo(a.deviceName));
      spans[1] = Span.up;
    }
    spans[0] = Span.def;
    spans[2] = Span.def;
  }

  Future<void> _sort3() async {
    if (spans[2] != Span.down) {
      sortState = 4;
      _pagingController.itemList
          .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      spans[2] = Span.down;
    } else {
      sortState = 5;
      _pagingController.itemList
          .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      spans[2] = Span.up;
    }
    spans[0] = Span.def;
    spans[1] = Span.def;
  }

  Future<void> filterSearchResults(String query) async {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateDevices);
    if (query.isNotEmpty) {
      List<DeviceJason> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.id.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceName.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceLocation.toLowerCase().contains(query.toLowerCase())) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        resNum = dummyListData.length.toString();
        _pagingController.itemList = dummyListData;
      });
      return;
    } else {
      setState(() {
        validate = false;
        sortState = 1;
        spans[0] = Span.up;
        spans[1] = Span.def;
        spans[2] = Span.def;
        duplicateDevices.forEach((element) => element.setHighLight(''));
        _pagingController.itemList = duplicateDevices;
        resNum = duplicateDevices.length.toString();
      });
    }
  }

  void sort() {
    if (sortState == 0) {
      _pagingController.itemList
          .sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      this
          .duplicateDevices
          .sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
    } else if (sortState == 1) {
      _pagingController.itemList
          .sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      this
          .duplicateDevices
          .sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
    } else if (sortState == 2) {
      _pagingController.itemList
          .sort((a, b) => a.deviceName.compareTo(b.deviceName));
      this
          .duplicateDevices
          .sort((a, b) => a.deviceName.compareTo(b.deviceName));
    } else if (sortState == 3) {
      _pagingController.itemList
          .sort((a, b) => b.deviceName.compareTo(a.deviceName));
      this
          .duplicateDevices
          .sort((a, b) => b.deviceName.compareTo(a.deviceName));
    } else if (sortState == 4) {
      _pagingController.itemList
          .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      this
          .duplicateDevices
          .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
    } else if (sortState == 5) {
      _pagingController.itemList
          .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      this
          .duplicateDevices
          .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
    }
  }

  @override
  void initState() {
    duplicateDevices = devices.where((h) => h.inActiveLast72()).toList();
    setState(() {
      resNum = duplicateDevices.length.toString();
      _pagingController.itemList = duplicateDevices;
      sort();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: CustomAppBarBack(context, "Inactive Devices"),
          preferredSize: const Size.fromHeight(50),
        ),
        body:
        // Stack(
        //   children: [
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
                  fillColor: Colors.white,
                  filled: true,
                  errorText: validate ? 'No result was found' : null,
                  labelText: "Search (" + resNum + " results)",
                  hintText: "Enter ID or Detail or Location",
                  contentPadding: EdgeInsets.all(10.0),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => setState(() {
                      searchController.clear();
                      filterSearchResults("");
                      FocusScopeNode currentFocus =
                      FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus.unfocus();
                      }
                    }),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
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
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      color: Colors.black12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sort1();
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
                                        TextSpan(text: 'ID'),
                                        WidgetSpan(
                                            child: (spans[0] == Span.def)
                                                ? SpanDefault()
                                                : (spans[0] == Span.up)
                                                ? SpanUp()
                                                : SpanDown()),
                                      ],
                                    ),
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sort2();
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
                                        TextSpan(text: 'Device Detail'),
                                        WidgetSpan(
                                            child: (spans[1] == Span.def)
                                                ? SpanDefault()
                                                : (spans[1] == Span.up)
                                                ? SpanUp()
                                                : SpanDown()),
                                      ],
                                    ),
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _sort3();
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
                                        TextSpan(text: 'Location'),
                                        WidgetSpan(
                                            child: (spans[2] == Span.def)
                                                ? SpanDefault()
                                                : (spans[2] == Span.up)
                                                ? SpanUp()
                                                : SpanDown()),
                                      ],
                                    ),
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
                      child: Stack(
                        children: [
                          //     ListView.builder(
                          //   shrinkWrap: false,
                          //   itemCount: items.length,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return InkWell(
                          //       onTap: () {
                          //         if (items[index].getLatitud() != 500 &&
                          //             items[index].getLongitud() != 500) {
                          //           // toast(items[index].getLatitud().toString()+","+ items[index].getLongitud().toString());
                          //           // String title =
                          //           //     items[index].getDeviceDetail();
                          //           // MaterialPageRoute(
                          //           //     builder: (context) => GoogleMapApp(
                          //           //         name: items[index].getId()));
                          //           clearFocus();
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => GoogleMapApp(
                          //                       name: items[index].getID())));
                          //           // MapsLauncher.launchCoordinates(
                          //           //       items[index].getLatitud(),
                          //           //       items[index].getLongitud(),
                          //           //     "title");
                          //         }
                          //       },
                          //       child: listItem(
                          //           context: context,
                          //           index: index,
                          //           ID: items[index].getId(),
                          //           Details: items[index].getDeviceDetail(),
                          //           Location: items[index].getLocation(),
                          //           HighLight: items[index].getHighLight()),
                          //     );
                          //   },
                          // ),
                          RefreshIndicator(
                            onRefresh: () => Future.sync(
                                  () => getDevices(),
                            ),
                            child: PagedListView<int, DeviceJason>(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              pagingController: _pagingController,
                              builderDelegate:
                              PagedChildBuilderDelegate<DeviceJason>(
                                firstPageErrorIndicatorBuilder: (_) =>
                                    SizedBox(),
                                newPageErrorIndicatorBuilder: (_) => SizedBox(),
                                firstPageProgressIndicatorBuilder: (_) =>
                                    SizedBox(),
                                newPageProgressIndicatorBuilder: (_) =>
                                    SizedBox(),
                                noItemsFoundIndicatorBuilder: (_) => SizedBox(),
                                noMoreItemsIndicatorBuilder: (_) => SizedBox(),
                                animateTransitions: true,
                                itemBuilder: (context, item, index) => Column(
                                  children: [
                                    Material(
                                      color: (index % 2 == 0)
                                          ? Colors.white
                                          : Color(0xf1f1f1f1),
                                      child: InkWell(
                                        onTap: () {
                                          ShowDevice(context, item);
                                        },
                                        child: Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: SubstringHighlight(
                                                    text: item.id,
                                                    term: item.highLight,
                                                    textStyleHighlight:
                                                    TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),

                                                  // Text(
                                                  //   ID,
                                                  //   textAlign: TextAlign.left,
                                                  //   style: TextStyle(fontSize: 12),
                                                  // ),
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: SubstringHighlight(
                                                    text: item.deviceName,
                                                    term: item.highLight,
                                                    textStyleHighlight:
                                                    TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   Details,
                                                  //   textAlign: TextAlign.left,
                                                  //   style: TextStyle(fontSize: 12),
                                                  // ),
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 10),
                                                  child: SubstringHighlight(
                                                    text: item.deviceLocation,
                                                    term: item.highLight,
                                                    textStyleHighlight:
                                                    TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   Location,
                                                  //   textAlign: TextAlign.left,
                                                  //   style: TextStyle(fontSize: 12),
                                                  // ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Loading(
                            loading: loading,
                          ),
                        ],
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

        //   ],
        // ),
      ),
    );
  }

  Future<void> getDevices() async {
    setState(() {
      loading = true;
    });
    try {
      final clientId = await load('client_id');
      if (clientId != '-1') {
        location = await RemoteApi.getLocationList();
        devices = await RemoteApi.getClientDevicesList(clientId);
        duplicateDevices = devices.where((h) => h.inActiveLast72()).toList();
        setState(() {
          resNum = duplicateDevices.length.toString();
          _pagingController.itemList = duplicateDevices;
          sort();
        });
      } else {
        toast('User was not found!');
      }
    } catch (error) {
      toast('Something wrong happened');
    }
    setState(() {
      loading = false;
    });
  }


  void clearFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
