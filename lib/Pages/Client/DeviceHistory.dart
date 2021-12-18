import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/HistoryJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/Cards/ShowDevice.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDateHor.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextFieldHor.dart';

import '../../public.dart';

class DeviceHistoryClient extends StatefulWidget {
  DeviceHistoryClient({Key key}) : super(key: key);

  @override
  _DeviceHistory createState() => _DeviceHistory();
}

class _DeviceHistory extends State<DeviceHistoryClient> with WidgetsBindingObserver {
  bool advancedSearchBool = false;
  bool loading = false;
  bool startIdError = false;
  bool endIdError = false;
  String deviceStatusAd = "";
  TextEditingController activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      startingId = new TextEditingController(),
      endingId = new TextEditingController();
  final PagingController<int, HistoryJason> _pagingController =
      PagingController(firstPageKey: 0);
  List<HistoryJason> allHistories = [];

  // List<DeviceJason> devices = [];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          centerTitle: true,
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
                  if (item == 0) {
                    show();
                  } else if (item == 1) {
                    setState(() {
                      reset();
                    });
                    advancedSearchBool = false;
                    refresh();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        const SizedBox(width: 8),
                        Text('Search'),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.clear),
                        const SizedBox(width: 8),
                        Text('Clear Search'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          title: Text(
            "Device History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => Future.sync(
              () => refresh(),
            ),
            child: PagedListView<int, HistoryJason>(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<HistoryJason>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (_) => SizedBox(),
                newPageErrorIndicatorBuilder: (_) => SizedBox(),
                firstPageProgressIndicatorBuilder: (_) {
                  // setState(() {
                  //   loading = true;
                  // });
                  return SizedBox();
                },
                newPageProgressIndicatorBuilder: (_) {
                  // setState(() {
                  //   loading = true;
                  // });
                  return SizedBox();
                },
                noItemsFoundIndicatorBuilder: (_) => SizedBox(),
                noMoreItemsIndicatorBuilder: (_) => SizedBox(),
                itemBuilder: (context, item, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    showHeader(index)
                        ? Container(
                            padding: EdgeInsets.only(
                                bottom: 16, top: 16, left: 16, right: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getDateString(item.changeDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Spacer(),
                                Text(
                                  getActive(item.changeDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Colors.teal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  " Active, ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Colors.teal,
                                        fontSize: 14,

                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  getInactive(item.changeDate),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  " Inactive",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : Offstage(),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(width: 20),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 2,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      shape: BoxShape.circle),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 2,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ), //Line
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            // color: Theme.of(context).accentColor,
                            child: Text(
                              DateFormat("hh:mm a").format(
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .parse(item.changeDate)),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: item.isActive()
                                          ? [Colors.green, Colors.teal]
                                          : [Colors.deepOrange, Colors.red]),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => ShowDevice(
                                        this.context, item.getDevice()),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Spacer(),
                                                Text(
                                                  item.isActive()
                                                      ? "Active"
                                                      : "Inactive",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                Visibility(
                                                  child: Text(
                                                    "Inactive for: " +
                                                        getTime(item
                                                            .inactivePeriod),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  visible: item.isActive() &&
                                                      getTime(item
                                                              .inactivePeriod)
                                                          .isNotEmpty,
                                                ),
                                                Visibility(
                                                  child: Text(
                                                    "Device has been activated",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                  visible: !item.isActive() &&
                                                      !item
                                                          .getDevice()
                                                          .inActiveLast72(),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "ID:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                            minWidth: 50,
                                          ),
                                          padding: EdgeInsets.only(
                                              right: 16, top: 16, bottom: 16),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              item.deviceId,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          // ],),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ), //item info
                        ],
                      ),
                    ),
                  ],
                ),
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
    );
  }

  bool showHeader(int index) {
    if (index == 0) {
      return true;
    }

    if (index - 1 >= 0) {
      try {
        String strCurrent = _pagingController.itemList[index].changeDate;
        String strBefore = _pagingController.itemList[index - 1].changeDate;
        bool year = getYear(strCurrent) != getYear(strBefore);
        bool month = getMonth(strCurrent) != getMonth(strBefore);
        bool day = getDay(strCurrent) != getDay(strBefore);

        if (year || month || day) {
          return true;
        }
      } catch (error) {}
    }
    return false;
  }

  String getActive(String date) {
    return _pagingController.itemList
        .where((h) => isSameDate(date, h.changeDate) && h.isActive())
        .toList()
        .length
        .toString();
  }

  String getInactive(String date) {
    return _pagingController.itemList
        .where((h) => isSameDate(date, h.changeDate) && !h.isActive())
        .toList()
        .length
        .toString();
  }

  bool isSameDate(String currentStr, String otherStr) {
    DateTime current = DateFormat('yyyy-MM-dd HH:mm:ss').parse(currentStr);
    DateTime other = DateFormat('yyyy-MM-dd HH:mm:ss').parse(otherStr);
    return current.year == other.year &&
        current.month == other.month &&
        current.day == other.day;
  }

  int getDay(String str) => DateFormat('yyyy-MM-dd HH:mm:ss').parse(str).day;

  int getMonth(String str) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').parse(str).month;

  int getYear(String str) => DateFormat('yyyy-MM-dd HH:mm:ss').parse(str).year;

  String getDateString(String str) {
    DateTime today = DateTime.now();
    if (getDay(str) == today.day &&
        getMonth(str) == today.month &&
        getYear(str) == today.year) {
      return "Today";
    }
    DateTime yesterday = DateTime(today.year, today.month, today.day - 1);
    if (getDay(str) == yesterday.day &&
        getMonth(str) == yesterday.month &&
        getYear(str) == yesterday.year) {
      return "Yesterday";
    }
    return DateFormat('EE, MMM dd, yyyy')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(str));
  }

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
                            refresh();
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
                                Text('All Device History'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      // color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ModalFilter(
                          //   value: clientAd,
                          //   title: "Client",
                          //   options: client,
                          //   passVal: (val) => setState(() => clientAd = val),
                          // ),

                          ModalFilter(
                            value: deviceStatusAd,
                            title: "Device Status",
                            options: deviceStatus,
                            passVal: (val) =>
                                setState(() => deviceStatusAd = val),
                            initial: true,
                            initialValue: "All Devices",
                          ),

                          SmartDateH(
                            controller: activationFromAd,
                            controller2: activationToAd,
                            title: "Filter Date",
                            hintText: "From",
                            hintText2: "To",
                          ),

                          SmartFieldH(
                            controller: startingId,
                            title: "Filter ID",
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
                    refresh();
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

  String getTime(String seconds) {
    int secondsInt = 0;
    try {
      secondsInt = int.parse(seconds);
      String secondString = "";
      int years = 0, months = 0, days = 0, hours = 0;
      while (secondsInt >= 3600) {
        if (secondsInt >= 31536000) {
          years++;
          secondsInt -= 31536000;
        } else if (secondsInt >= 2628288) {
          months++;
          secondsInt -= 2628288;
        } else if (secondsInt >= 86400) {
          days++;
          secondsInt -= 86400;
        } else if (secondsInt >= 3600) {
          hours++;
          secondsInt -= 3600;
        }
      }

      if (years > 0) {
        secondString += years.toString() + " yrs";
        if (months > 0 || days > 0 || hours > 0) {
          secondString += ", ";
        }
      }
      if (months > 0) {
        secondString += months.toString() + " m";
        if (days > 0 || hours > 0) {
          secondString += ", ";
        }
      }
      if (days > 0) {
        secondString += days.toString() + " d";
        if (hours > 0) {
          secondString += ", ";
        }
      }

      if (hours > 0) {
        secondString += hours.toString() + " hrs";
      }

      // return years.toString()+", "+months.toString()+", "+days.toString()+", "+hours.toString();
      return secondString;
    } catch (error) {
      return "";
    }
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
    return
      // clientAd == "" &&
        deviceStatusAd == "" &&
        activationFromAd.text == "" &&
        activationToAd.text == "" &&
        startingId.text == "" &&
        endingId.text == "";
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

  void reset() {
    // clientAd = "";
    deviceStatusAd = "";
    activationFromAd.text = "";
    activationToAd.text = "";
    startingId.text = "";
    endingId.text = "";
    startIdError = false;
    endIdError = false;
  }

  void refresh() {
    if (!loading) {
      progress(true);
      _fetchPage().then((value) {
        allHistories = value;
        if (advancedSearchBool) {
          _pagingController.itemList =
              allHistories.where((element) => filterElement(element)).toList();
        } else {
          _pagingController.itemList = allHistories;
        }

        if (loading) {
          progress(false);
        }
        if (_pagingController.itemList.isEmpty) {
          toast("No history available!");
        }
      });
    }
  }

  bool filterElement(HistoryJason element) {
    // bool filterClient;

    // if (clientAd.isEmpty) {
    //   filterClient = true;
    // } else {
    //   DeviceJason device = element.getDevice();
    //   filterClient = client[getInt(device.client) - 1].contains(clientAd);
    // }

    bool filterStatus = (deviceStatusAd.isEmpty)
        ? true
        : ((element.isActive() && deviceStatusAd == "Active Devices") ||
            (!element.isActive() && deviceStatusAd == "Inactive Devices"));

    bool filterDateFrom;
    try {
      filterDateFrom = (activationFromAd.text.isEmpty ||
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(element.changeDate)
              .isAfter(DateFormat('dd-MM-yyyy').parse(activationFromAd.text)) ||
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(element.changeDate)
              .isAtSameMomentAs(
                  DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
    } catch (Exception) {
      filterDateFrom = false;
    }
    bool filterDateTo;
    try {
      filterDateTo = (activationToAd.text.isEmpty ||
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(element.changeDate)
              .isBefore(DateFormat('dd-MM-yyyy').parse(activationToAd.text)) ||
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(element.changeDate)
              .isAtSameMomentAs(
                  DateFormat('dd-MM-yyyy').parse(activationToAd.text)));
    } catch (Exception) {
      filterDateTo = false;
    }

    bool filterIdFrom = startingId.text.isEmpty ||
        getInt(element.deviceId) >= getInt(startingId.text);
    bool filterIdTo = endingId.text.isEmpty ||
        getInt(element.deviceId) <= getInt(endingId.text);
    return
      // filterClient &&
        filterStatus &&
        filterDateFrom &&
        filterDateTo &&
        filterIdFrom &&
        filterIdTo;
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

  void progress(bool load) {
    setState(() {
      this.loading = load;
    });
  }

  Future<List<HistoryJason>> _fetchPage() async {
    try {
      // devices = await RemoteApi.getDevicesList();
      return await RemoteApi.getClientHistory();
    } catch (error) {
      _pagingController.error = error;
      print(error);
      return [];
    }
  }
}
