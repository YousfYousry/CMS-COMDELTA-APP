// import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';

// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DeviceLogsAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Functions/ExportExcel.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';

// import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
// import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/cupertino.dart';
// import '../../Choices.dart';

const PrimaryColor = const Color(0xff0065a3);
enum Span { def, up, down }

// var spanUp = WidgetSpan(
//       child: Padding(
//         padding: EdgeInsets.only(left: 2, bottom: 2),
//         child: ImageIcon(
//           AssetImage('assets/image/sortup.png'),
//           size: 12,
//           color: Colors.black,
//         ),
//       ),
//     ),
//     spanDown = WidgetSpan(
//       child: Padding(
//         padding: EdgeInsets.only(left: 2, bottom: 2),
//         child: ImageIcon(
//           AssetImage('assets/image/sortdown.png'),
//           size: 12,
//           color: Colors.black,
//         ),
//       ),
//     ),
//     spanDefault = WidgetSpan(
//       child: Transform.rotate(
//         angle: 90 * math.pi / 180,
//         child: Icon(
//           Icons.sync_alt,
//           size: 15,
//           color: Colors.grey,
//         ),
//       ),
//     );

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

class TitleElement extends StatelessWidget {
  final double width, height;
  final String title;
  final Span span;
  final func;
  final int index;

  const TitleElement(
      {Key key,
      this.width,
      this.height,
      this.title,
      this.span,
      this.func,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: InkWell(
        onTap: sort,
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
                  WidgetSpan(
                      child: (span == Span.def)
                          ? SpanDefault()
                          : (span == Span.up)
                              ? SpanUp()
                              : SpanDown()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sort() {
    func(this.index);
  }
}

class Value extends StatelessWidget {
  final double width, height;
  final String title, high;
  final bool border;

  const Value(
      {Key key, this.height, this.width, this.title, this.high, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class ValueBulb extends StatelessWidget {
  final double width, height;
  final String title, high;
  final bool border;

  const ValueBulb(
      {Key key, this.height, this.width, this.title, this.high, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class DeviceLogs extends StatefulWidget {
  final device;

  DeviceLogs(this.device);

  @override
  _DeviceLogs createState() => _DeviceLogs();
}

class _DeviceLogs extends State<DeviceLogs> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;

  // String searchTerm="";

  // static const _pageSize = 0;
  final PagingController<int, LogJason> _pagingController =
      PagingController(firstPageKey: 0);

  // final PagingController<int, LogJason> controller =
  // PagingController(firstPageKey: 0);

  var spans = [
    Span.up,
    Span.def,
    Span.def,
    Span.def,
    Span.def,
    Span.def,
    Span.def,
    Span.def,
    Span.def
  ];

  List<LogJason> allLogs = [];

  LinkedScrollControllerGroup horizontal;
  LinkedScrollControllerGroup vertical;

  ScrollController vertical1;
  ScrollController vertical2;
  ScrollController horizontal1;
  ScrollController horizontal2;

  Future<void> setSpans(int index) async{
    bool isUp = (spans[index] != Span.down);
    setState(() {
      _pagingController.itemList.sort((a, b) => isUp
          ? a.getE(index).compareTo(b.getE(index))
          : b.getE(index).compareTo(a.getE(index)));
      for (int i = 0; i < spans.length; i++) {
        spans[i] = Span.def;
      }
      spans[index] = isUp ? Span.down : Span.up;
    });
  }

  Future<void> filterSearchResults(String query) async {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(allLogs);
    if (query.isNotEmpty) {
      List<LogJason> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.isFound(query)) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        // logs.clear();
        // logs.addAll(dummyListData);
        _pagingController.itemList = dummyListData;
      });
      return;
    } else {
      setState(() {
        validate = false;
        allLogs.forEach((element) => element.setHighLight(''));
        _pagingController.itemList = allLogs;
        // logs.clear();
        // logs.forEach((item) => item.setHighLight(''));
      });
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      if (!loading) progress(true);
      _fetchPage().then((value) => (loading) ? progress(false) : {});
    });

    // _pagingController.addListener(() {
    //
    //
    // });
    // getLogs();
    super.initState();
    horizontal = LinkedScrollControllerGroup();
    vertical = LinkedScrollControllerGroup();

    vertical1 = vertical.addAndGet();
    vertical2 = vertical.addAndGet();
    horizontal1 = horizontal.addAndGet();
    horizontal2 = horizontal.addAndGet();
  }

  Future<void> _fetchPage() async {
    try {
      // toast("started");
      // loading = true;

      // this.duplicateLogs = ;
      // progress(true);
      allLogs.addAll(await RemoteApi.getList(widget.device.id));
      _pagingController.appendLastPage(allLogs);
      // setState(() {
      //   this.logs.clear();
      //   this.logs.addAll(this.duplicateLogs);
      //   loading = false;
      // });

      // final newItems = await getAllLogs(pageKey, _pageSize);
      // toast("finished");
      // toast(newItems.length.toString());
      // final isLastPage = newItems.length < _pageSize;
      // if (isLastPage) {
      //   _pagingController.appendLastPage(newItems);
      // } else {
      //   final nextPageKey = pageKey + newItems.length;
      //   _pagingController.appendPage(newItems, null);
      // }
      // this.logs.addAll(newItems);
      // this.duplicateLogs.addAll(newItems);
    } catch (error) {
      _pagingController.error = error;
      print(error);
    }
    // progress(false);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   horizontal = LinkedScrollControllerGroup();
        //   vertical = LinkedScrollControllerGroup();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
        // });
      },
      child: Scaffold(
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: DeviceLogsAppBar(
              context,
              "Device " + widget.device.id + " Logs",
              showDeviceDetails,
              _pagingController.refresh,
              pdf,
              excel),
          preferredSize: const Size.fromHeight(50),
        ),
        // resizeToAvoidBottomInset: false,
        body:

            // Stack(
            //   children: [
            Column(
          children: [
            Container(
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
                          TitleElement(
                            width: 130,
                            height: 30,
                            title: "Detail",
                            span: spans[0],
                            func: setSpans,
                            index: 0,
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: horizontal1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L1#",
                                      span: spans[1],
                                      func: setSpans,
                                      index: 1),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L1@",
                                      span: spans[2],
                                      func: setSpans,
                                      index: 2),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L2#",
                                      span: spans[3],
                                      func: setSpans,
                                      index: 3),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L2@",
                                      span: spans[4],
                                      func: setSpans,
                                      index: 4),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L3#",
                                      span: spans[5],
                                      func: setSpans,
                                      index: 5),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "L3@",
                                      span: spans[6],
                                      func: setSpans,
                                      index: 6),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 80,
                                      height: 30,
                                      title: "Battery",
                                      span: spans[7],
                                      func: setSpans,
                                      index: 7),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TitleElement(
                                      width: 70,
                                      height: 30,
                                      title: "Rssi",
                                      span: spans[8],
                                      func: setSpans,
                                      index: 8),
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
                        child: Stack(
                          children: [
                            RefreshIndicator(
                              onRefresh: () => Future.sync(
                                () => _pagingController.refresh(),
                              ),
                              notificationPredicate:
                                  (ScrollNotification notification) {
                                return true;
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 131,
                                    child: NotificationListener<
                                        OverscrollIndicatorNotification>(
                                      onNotification:
                                          (OverscrollIndicatorNotification
                                              overscroll) {
                                        overscroll.disallowGlow();
                                        return false;
                                      },
                                      child: PagedListView<int, LogJason>(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        scrollController: vertical1,
                                        shrinkWrap: true,
                                        pagingController: _pagingController,
                                        builderDelegate:
                                            PagedChildBuilderDelegate<LogJason>(
                                          animateTransitions: true,
                                          firstPageErrorIndicatorBuilder: (_) =>
                                              SizedBox(),
                                          newPageErrorIndicatorBuilder: (_) =>
                                              SizedBox(),
                                          firstPageProgressIndicatorBuilder:
                                              (_) {
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
                                          noItemsFoundIndicatorBuilder: (_) =>
                                              SizedBox(),
                                          noMoreItemsIndicatorBuilder: (_) =>
                                              SizedBox(),
                                          itemBuilder: (context, item, index) =>
                                              Container(
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
                                                text: item.createDate,
                                                term: item.highLight,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      controller: horizontal2,
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: 577,
                                        child: NotificationListener<
                                            OverscrollIndicatorNotification>(
                                          onNotification:
                                              (OverscrollIndicatorNotification
                                                  overscroll) {
                                            overscroll.disallowGlow();
                                            return true;
                                          },
                                          child: PagedListView<int, LogJason>(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollController: vertical2,
                                            pagingController: _pagingController,
                                            builderDelegate:
                                                PagedChildBuilderDelegate<
                                                    LogJason>(
                                              firstPageErrorIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              newPageErrorIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              firstPageProgressIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              newPageProgressIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              noItemsFoundIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              noMoreItemsIndicatorBuilder:
                                                  (_) => SizedBox(),
                                              animateTransitions: true,
                                              itemBuilder:
                                                  (context, item, index) =>
                                                      Container(
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
                                                    Value(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.lid1,
                                                        high: item.highLight,
                                                        border: true),
                                                    ValueBulb(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.ls1,
                                                        border: true),
                                                    Value(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.lid2,
                                                        high: item.highLight,
                                                        border: true),
                                                    ValueBulb(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.ls2,
                                                        border: true),
                                                    Value(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.lid3,
                                                        high: item.highLight,
                                                        border: true),
                                                    ValueBulb(
                                                        height: 30,
                                                        width: 71,
                                                        title: item.ls3,
                                                        border: true),
                                                    Value(
                                                        height: 30,
                                                        width: 81,
                                                        title:
                                                            item.batteryValue,
                                                        high: item.highLight,
                                                        border: true),
                                                    Value(
                                                        height: 30,
                                                        width: 70,
                                                        title: item.rssiValue,
                                                        high: item.highLight,
                                                        border: false),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //
                            // PagedListView<int, LogJason>(
                            //   // physics: NeverScrollableScrollPhysics(),
                            //   // scrollController: vertical.addAndGet(),
                            //   // shrinkWrap: false,
                            //   addAutomaticKeepAlives: false,
                            //   pagingController: _pagingController,
                            //   builderDelegate: PagedChildBuilderDelegate<LogJason>(
                            //     animateTransitions: true,
                            //

                            //
                            //     // transitionDuration: const Duration(milliseconds: 500),
                            //     itemBuilder: (context, item, index) =>
                            //
                            //
                            //
                            //
                            //
                            // Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: <Widget>[
                            //
                            //             SizedBox(
                            //               width: 131,
                            //               child:
                            //             // PagedListView<int, LogJason>(
                            //             //   physics: NeverScrollableScrollPhysics(),
                            //             //   // scrollController: vertical.addAndGet(),
                            //             //   shrinkWrap: true,
                            //             //   pagingController: _pagingController,
                            //             //   builderDelegate: PagedChildBuilderDelegate<LogJason>(
                            //             //     itemBuilder: (context, item, index) =>
                            //           Container(
                            //                 decoration: BoxDecoration(
                            //                   border: Border(
                            //                     right: BorderSide(
                            //                         width: 1.0,
                            //                         color: Colors.grey),
                            //                     bottom: BorderSide(
                            //                         width: 1.0,
                            //                         color: Colors.grey),
                            //                   ),
                            //                   color: (index % 2 == 0)
                            //                       ? Colors.white
                            //                       : Color(0xf1f1f1f1),
                            //                 ),
                            //                 height: 30,
                            //                 child: Align(
                            //                   alignment: Alignment.center,
                            //                   child: SubstringHighlight(
                            //                     text: item.createDate,
                            //                     term: item.highLight,
                            //                     textStyleHighlight: TextStyle(
                            //                       fontSize: 13,
                            //                       color: Colors.red,
                            //                       fontWeight: FontWeight.bold,
                            //                     ),
                            //                     textStyle: TextStyle(
                            //                       fontSize: 12,
                            //                       color: Colors.black,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            // //             ),
                            // //
                            // // ),
                            // ),
                            //             Flexible(
                            //               child: SingleChildScrollView(
                            //                 physics: ScrollPhysics(),
                            //                 controller: horizontal.addAndGet(),
                            //                 scrollDirection: Axis.horizontal,
                            //                 child:
                            //                 SizedBox(
                            //                   width: 577,
                            //                   child:
                            //                 // PagedListView<int, LogJason>(
                            //                 //   physics: NeverScrollableScrollPhysics(),
                            //                 //   // scrollController: vertical.addAndGet(),
                            //                 //   shrinkWrap: true,
                            //                 //   pagingController: _pagingController,
                            //                 //   builderDelegate: PagedChildBuilderDelegate<LogJason>(
                            //                 //     itemBuilder: (context, item, index) =>
                            //                 Container(
                            //                     decoration: BoxDecoration(
                            //                       border: Border(
                            //                         bottom: BorderSide(
                            //                             width: 1.0,
                            //                             color: Colors.grey),
                            //                       ),
                            //                       color: (index % 2 == 0)
                            //                           ? Colors.white
                            //                           : Color(0xf1f1f1f1),
                            //                     ),
                            //                     height: 30,
                            //                     child: Row(
                            //                       children: [
                            //                         Value(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.lid1,
                            //                             high: item.highLight,
                            //                             border: true),
                            //                         ValueBulb(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.ls1,
                            //                             border: true),
                            //                         Value(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.lid2,
                            //                             high: item.highLight,
                            //                             border: true),
                            //                         ValueBulb(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.ls2,
                            //                             border: true),
                            //                         Value(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.lid3,
                            //                             high: item.highLight,
                            //                             border: true),
                            //                         ValueBulb(
                            //                             height: 30,
                            //                             width: 71,
                            //                             title: item.ls3,
                            //                             border: true),
                            //                         Value(
                            //                             height: 30,
                            //                             width: 81,
                            //                             title: item.batteryValue,
                            //                             high: item.highLight,
                            //                             border: true),
                            //                         Value(
                            //                             height: 30,
                            //                             width: 70,
                            //                             title: item.rssiValue,
                            //                             high: item.highLight,
                            //                             border: false),
                            //                       ],
                            //                     ),
                            //                   ),
                            //               //   ),
                            //               // ),
                            //             ),
                            //
                            //
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //
                            //
                            //     ),
                            //
                            // ),
                            Center(
                              child: Loading(
                                loading: loading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ),

                    // child: Container(
                    //   color: Colors.white,
                    //   child: SingleChildScrollView(
                    //     physics: ScrollPhysics(),

                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         SizedBox(
                    //           width: 131,
                    //           child: ListView.builder(
                    //             physics: NeverScrollableScrollPhysics(),
                    //             shrinkWrap: true,
                    //             itemCount: logs.length,
                    //             itemBuilder: (context, index) {
                    //               return Container(
                    //                 decoration: BoxDecoration(
                    //                   border: Border(
                    //                     right: BorderSide(
                    //                         width: 1.0,
                    //                         color: Colors.grey),
                    //                     bottom: BorderSide(
                    //                         width: 1.0,
                    //                         color: Colors.grey),
                    //                   ),
                    //                   color: (index % 2 == 0)
                    //                       ? Colors.white
                    //                       : Color(0xf1f1f1f1),
                    //                 ),
                    //                 height: 30,
                    //                 child: Align(
                    //                   alignment: Alignment.center,
                    //                   child: SubstringHighlight(
                    //                     text: logs[index].createDate,
                    //                     term: logs[index].highLight,
                    //                     textStyleHighlight: TextStyle(
                    //                       fontSize: 13,
                    //                       color: Colors.red,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                     textStyle: TextStyle(
                    //                       fontSize: 12,
                    //                       color: Colors.black,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //         Flexible(
                    //           child: SingleChildScrollView(
                    //             physics: ScrollPhysics(),
                    //             controller: _numbers,
                    //             scrollDirection: Axis.horizontal,
                    //             child: SizedBox(
                    //               width: 577,
                    //               child: ListView.builder(
                    //                 physics:
                    //                     NeverScrollableScrollPhysics(),
                    //                 shrinkWrap: true,
                    //                 itemCount: logs.length,
                    //                 itemBuilder: (context, index) {
                    //                   return Container(
                    //                     decoration: BoxDecoration(
                    //                       border: Border(
                    //                         bottom: BorderSide(
                    //                             width: 1.0,
                    //                             color: Colors.grey),
                    //                       ),
                    //                       color: (index % 2 == 0)
                    //                           ? Colors.white
                    //                           : Color(0xf1f1f1f1),
                    //                     ),
                    //                     height: 30,
                    //                     child: Row(
                    //                       children: [
                    //                         Value(
                    //                            height : 30,
                    //                            width  : 71,
                    //                            title  : logs[index].lid1,
                    //                            high   : logs[index].highLight,
                    //                            border : true),
                    //                         ValueBulb(
                    //                             height :        30,
                    //                             width  :        71,
                    //                             title  :       logs[index].ls1,
                    //                             border :     true),
                    //                        Value(
                    //                         height :   30,
                    //                         width  :   71,
                    //                         title  :   logs[index].lid2,
                    //                         high   :   logs[index].highLight,
                    //                         border :   true),
                    //                         ValueBulb(
                    //                         height :    30,
                    //                         width  :    71,
                    //                         title  :   logs[index].ls2,
                    //                         border :    true),
                    //                         Value(
                    //                          height :  30,
                    //                          width  :  71,
                    //                          title  :  logs[index].lid3,
                    //                          high   :  logs[index].highLight,
                    //                          border :  true),
                    //                         ValueBulb(
                    //                         height :    30,
                    //                         width  :    71,
                    //                         title  :   logs[index].ls3,
                    //                         border :    true),
                    //                         Value(
                    //                          height :  30,
                    //                          width  :  81,
                    //                          title  :  logs[index].batteryValue,
                    //                          high   :  logs[index].highLight,
                    //                          border :  true),
                    //                         Value(
                    //                          height :   30,
                    //                          width  :   70,
                    //                          title  :   logs[index].rssiValue,
                    //                          high   :   logs[index].highLight,
                    //                          border :   false),
                    //                       ],
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //   Center(
        //     child: Loading(
        //       loading: loading,
        //     ),
        //   ),
        // ],
        // ),
      ),
    );
  }

  void progress(bool load) {
    setState(() {
      this.loading = load;
    });
  }

  // @override
  // bool get wantKeepAlive => true;
  // Future<List<LogJason>> getAllLogs(int offset, int limit) async{
  //   setState(() {
  //     loading = true;
  //   });
  //   http.post(
  //       Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
  //       body: {
  //         'device_id': widget.device.id,
  //         'offset': offset.toString(),
  //         'limit': limit.toString(),
  //         'search_term': "",
  //       }).then((value) {
  //     if (value.statusCode == 200) {
  //       List<LogJason> logs = [];
  //       List<dynamic> values = [];
  //       values = json.decode(value.body);
  //
  //       if (values.length > 0) {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             logs.add(LogJason.fromJson(map));
  //           }
  //         }
  //       }
  //       toast("finished ");
  //       return logs;
  //       // showLogs(logs);
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       throw Exception("Unable to get Log list");
  //     }
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     toast('Error: ' + error.message);
  //     return null;
  //   });
  //   return null;
  // }

  // void getLogs() {
  //   setState(() {
  //     loading = true;
  //   });
  //   http.post(
  //       Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
  //       body: {
  //         'device_id': widget.device.id,
  //       }).then((value) {
  //     if (value.statusCode == 200) {
  //       List<LogJason> logs = [];
  //       List<dynamic> values = [];
  //       values = json.decode(value.body);
  //
  //       if (values.length > 0) {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             logs.add(LogJason.fromJson(map));
  //           }
  //         }
  //       }
  //       toast("finished ");
  //       // showLogs(logs);
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       throw Exception("Unable to get Log list");
  //     }
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     toast('Error: ' + error.message);
  //   });
  // }
  //
  // void showLogs(List<LogJason> logs) {
  //   logs.sort((a, b) => b.createDate.compareTo(a.createDate));
  //   this.duplicateLogs.clear();
  //   this.logs.clear();
  //   // setState(() {
  //   //   this.logs.addAll(logs);
  //   //   loading = false;
  //   // });
  //   // this.duplicateLogs.addAll(logs);
  //   // toast("FFFFFFFFFFF");
  // }

  Future<void> pdf() async {
    if (_pagingController.itemList.isEmpty) {
      toast("No logs available");
      return;
    }

    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        PdfDocument document = PdfDocument();
        document.pageSettings.margins.all = 0;

        PdfFont font = PdfStandardFont(
          PdfFontFamily.timesRoman,
          12,
        );

        PdfFont fontTitle = PdfStandardFont(
          PdfFontFamily.timesRoman,
          12,
          style: PdfFontStyle.bold,
        );

        PdfFont fontGridTitle = PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
          style: PdfFontStyle.bold,
        );

        PdfFont fontGrid = PdfStandardFont(
          PdfFontFamily.timesRoman,
          10,
        );

        String text =
            'This is a computer-generated document. No signature is required.\nContact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898';
        Size size = font.measureString(text);
        Size size1 = font.measureString(
            'Contact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898');
        Size size2 = font.measureString('Contact Us: ');
        Size size3 = font.measureString('Contact Us: info@comdelta.com.my |');
        Size size4 = fontTitle.measureString('Device Log');
        Size size5 = fontGridTitle.measureString('2021-01-11 06:48:47');

        PdfPage page = document.pages.add();
        PdfGraphics graphics = page.graphics;
        double width = graphics.clientSize.width,
            height = graphics.clientSize.height;

        PdfGrid grid = PdfGrid();
        grid.style = PdfGridStyle(
            font: fontGrid,
            cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

        grid.columns.add(count: 6);
        grid.headers.add(1);

        PdfGridRow header = grid.headers[0];
        header.cells[0].value = 'Date';
        header.cells[1].value = 'Light 1\n(LOW)';
        header.cells[2].value = 'Light 2\n(LOW)';
        header.cells[3].value = 'Light 3\n(MEDIUM)';
        header.cells[4].value = 'Battery Status';
        header.cells[5].value = 'RSSI';

        for (int i = 0; i < 6; i++) {
          header.cells[i].style = PdfGridCellStyle(
              format: PdfStringFormat(
                  alignment: (i == 0)
                      ? PdfTextAlignment.left
                      : PdfTextAlignment.center),
              font: fontGridTitle,
              cellPadding: PdfPaddings(
                  left: (i == 0) ? 5 : 2, right: 2, top: 2, bottom: 2));
          header.cells[i].style.backgroundBrush =
              PdfSolidBrush(PdfColor(0, 101, 163));
          header.cells[i].style.textBrush =
              PdfSolidBrush(PdfColor(255, 255, 255));
          header.cells[i].style.textBrush =
              PdfSolidBrush(PdfColor(255, 255, 255));
        }

        PdfGridRow row;

        for (int i = 0; i < _pagingController.itemList.length; i++) {
          row = grid.rows.add();
          row.cells[0].value = _pagingController.itemList[i].createDate;
          row.cells[1].value = _pagingController.itemList[i].ls1.contains("1") ? "ON" : "OFF";
          row.cells[2].value = _pagingController.itemList[i].ls2.contains("1") ? "ON" : "OFF";
          row.cells[3].value = _pagingController.itemList[i].ls3.contains("1") ? "ON" : "OFF";
          row.cells[4].value = _pagingController.itemList[i].batteryValue;
          row.cells[5].value = _pagingController.itemList[i].rssiValue;

          for (int l = 0; l < 6; l++) {
            row.cells[l].style = PdfGridCellStyle(
                format: PdfStringFormat(
                    alignment: (l == 0)
                        ? PdfTextAlignment.left
                        : PdfTextAlignment.center),
                font: fontGrid,
                cellPadding: PdfPaddings(
                    left: (l == 0) ? 5 : 2, right: 2, top: 2, bottom: 2));
            if (i % 2 != 0) {
              row.cells[l].style.backgroundBrush = PdfBrushes.lightGray;
            }
          }
        }

        grid.columns[0].width = size5.width + 10;
        grid.repeatHeader = true;

        grid.draw(
            page: page,
            format: PdfLayoutFormat(
                paginateBounds: Rect.fromLTWH(
                    40, 40, width - 40, height - (size.height + 30))),
            bounds: Rect.fromLTWH(
                40,
                (width / 7) + 100 + size4.height + (size3.height * 2),
                width - 40,
                height - (size.height + 30)));

        for (int num = 0; num < document.pages.count; num++) {
          page = document.pages[num];
          graphics = document.pages[num].graphics;
          Rect rect =
              Rect.fromLTWH((width) / 2, height - size.height - 20, 0, 0);
          PdfGraphicsState state = graphics.save();
          graphics.setTransparency(0.20);
          graphics.drawImage(PdfBitmap(await _readImageData('water.png')),
              Rect.fromLTWH(0, 0, width, height));
          graphics.restore(state);
          graphics.drawString(text, font,
              brush: PdfBrushes.black,
              bounds: rect,
              format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
              ));
          PdfTextWebLink(
                  url: 'mailto:info@comdelta.com.my',
                  text: ' info@comdelta.com.my',
                  font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
                      style: PdfFontStyle.underline),
                  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                  pen: PdfPens.cornflowerBlue,
                  format: PdfStringFormat(
                      alignment: PdfTextAlignment.left,
                      lineAlignment: PdfVerticalAlignment.middle))
              .draw(
                  page,
                  Offset((width - size1.width) / 2 + size2.width,
                      height - size1.height - 20));
          PdfTextWebLink(
                  url: 'www.comdelta.com.my',
                  text: ' www.comdelta.com.my',
                  font: PdfStandardFont(PdfFontFamily.timesRoman, 12,
                      style: PdfFontStyle.underline),
                  brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                  pen: PdfPens.cornflowerBlue,
                  format: PdfStringFormat(
                      alignment: PdfTextAlignment.left,
                      lineAlignment: PdfVerticalAlignment.middle))
              .draw(
                  page,
                  Offset((width - size1.width) / 2 + size3.width,
                      height - size1.height - 20));
        }

        page = document.pages[0];
        graphics = document.pages[0].graphics;

        graphics.drawImage(
            PdfBitmap(await _readImageData('logonew.png')),
            Rect.fromLTWH(
                40, 40, (width / 7) * 2.181818181818181818182, width / 7));

        graphics.drawString('Device Log', fontTitle,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(40, 40 + width / 7 + 10, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(
            'Date of generated: ' +
                DateFormat('dd MMM yyyy').format(DateTime.now()),
            font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(width - 40, 40 + width / 7 + 10, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
            ));

        String str1 = 'Client: ' + compress(widget.device.client);
        String str2 = 'Device name: ' + widget.device.deviceName;
        String str3 = 'Height: ' + widget.device.deviceHeight;
        String str4 = 'Location: ' + widget.device.deviceLocation;

        String str5 = 'Site Details: ' + widget.device.deviceDetails;
        String str6 = "";
        if (widget.device.activationDate.toString().isNotEmpty)
          str6 = 'Activation date: ' + widget.device.activationDate;

        graphics.drawString(str1, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(40, 40 + width / 7 + 30 + size4.height, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(str2, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH((width - 80) / 4 + 40,
                40 + width / 7 + 30 + size4.height, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(str3, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH((width - 80) / 2 + 40,
                40 + width / 7 + 30 + size4.height, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(str4, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(
                width - 40, 40 + width / 7 + 30 + size4.height, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
            ));

        graphics.drawString(str5, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(
                40,
                width / 7 + 75 + size4.height + size3.height,
                str6.isEmpty ? (width - 80) : (width - 80) / 2,
                0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        graphics.drawString(str6, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH((width - 80) / 2 + 40,
                width / 7 + 75 + size4.height + size3.height, 0, 0),
            format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
            ));

        saveAndLaunchFile(document, widget.device.id.toString() + '.pdf');
      } else if (value.isPermanentlyDenied) {
        toast("Accept permission to proceed!");
        await openAppSettings();
      } else if (value.isDenied) {
        toast("Permission is denied");
      } else if (value.isRestricted) {
        toast("Permission is restricted");
      } else if (value.isLimited) {
        toast("Permission is limited");
      }
      return true;
    });
  }

  Future<void> excel() async {
    if (_pagingController.itemList.isEmpty) {
      toast("No logs available");
      return;
    }

    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        ExportExcel(widget.device.id, this._pagingController.itemList, (bool loading) {
          setState(() {
            this.loading = loading;
          });
        });
      } else if (value.isPermanentlyDenied) {
        toast("Accept permission to proceed!");
        await openAppSettings();
      } else if (value.isDenied) {
        toast("Permission is denied");
      } else if (value.isRestricted) {
        toast("Permission is restricted");
      } else if (value.isLimited) {
        toast("Permission is limited");
      }
      return true;
    });
  }

  String compress(String str) {
    if (str.contains("Research & Development Department")) {
      return "R&D";
    } else if (str.contains("Comdelta Technologies")) {
      return "Comdelta";
    } else if (str.length > 11) {
      return str.substring(0, 11) + "...";
    } else {
      return str;
    }
  }

  // Future<String> getDirectoryPath() async {
  //   Directory appDocDirectory = await getApplicationDocumentsDirectory();
  //
  //   Directory directory =
  //   await new Directory(appDocDirectory.path + '/' + 'dir')
  //       .create(recursive: true);
  //
  //   return directory.path;
  // }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/image/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> saveAndLaunchFile(PdfDocument document, String name) async {
    List<int> bytes = document.save();
    document.dispose();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\' + name.toString()
        : '$path/' + name.toString();
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  void showDeviceDetails() {
    ShowDevice(context, widget.device);
  }
}
