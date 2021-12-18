import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/Classes/DeviceCount.dart';
import 'package:login_cms_comdelta/Classes/DeviceCountHolder.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/HistoryJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Pages/Admin/DisplayDevices.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DeviceCountAppBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../public.dart';

class TitleElement extends StatelessWidget {
  final double width, height;
  final String title;
  final Span span;
  final func;
  final int index;
  final double textSize;
  final bool border;

  const TitleElement(
      {Key key,
      this.width=0,
      this.height,
      this.title,
      this.span,
      this.func,
      this.border = false,
      this.textSize = 14,
      this.index})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: width!=0?0:1,
      child:Container(
      width: width,
      height: height,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: border ? 1.0 : 0, color: Colors.grey),
          ),
        ),
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
                  fontSize: textSize,
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
    ),);
  }

  void sort() {
    func(this.index);
  }
}

class Value extends StatelessWidget {
  final double width, height;
  final String title, high;
  final bool border;
  final onClick;

  const Value(
      {Key key, this.height, this.width=0, this.title, this.high, this.border, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: width!=0?0:1,
      child:Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Container(
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
          ),
        ),
      ),
    );
  }
}

class DeviceCountHistory extends StatefulWidget {
  final clientId;

  DeviceCountHistory({this.clientId});

  @override
  _DeviceCountHistory createState() => _DeviceCountHistory();
}

class _DeviceCountHistory extends State<DeviceCountHistory> {
  TextEditingController searchController = new TextEditingController();
  bool loading = false, validate = false;
  DateTime selectedDay = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  String resNum = "0";

  final PagingController<int, DeviceCount> _pagingController =
      PagingController(firstPageKey: 0);

  var spans = [
    Span.up,
    Span.def,
    Span.def,
    Span.def,
  ];

  List<DeviceCount> counts = [];

  Future<void> setSpans(int index) async {
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
    if (query.isNotEmpty) {
      List<DeviceCount> dummyListData = [];
      counts.forEach((item) {
        if (item.isFound(query)) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        _pagingController.itemList = dummyListData;
        resNum = dummyListData.length.toString();
      });
    } else {
      setState(() {
        validate = false;
        if (spans[0] != Span.up) {
          counts.sort((a, b) => b.getE(0).compareTo(a.getE(0)));
          spans[0] = Span.up;
          for (int i = 1; i < spans.length; i++) {
            spans[i] = Span.def;
          }
        }
        counts.forEach((element) => element.setHighLight(''));
        _pagingController.itemList = counts;
        resNum = counts.length.toString();
      });
    }
  }

  Future<void> refresh() async{
    if (!loading) {
      progress(true);
      await _fetchPage().then((value) {
        if (loading) {
          progress(false);
        }
        if (counts.isEmpty) {
          toast("No logs were found!");
        }
      });
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  Future<void> _fetchPage() async {
    try {
      counts.clear();
      List<HistoryJason> history = await RemoteApi.getHistoryList();
      devices = await RemoteApi.getDevicesList();
      List<DeviceCountHolder> deviceHolder = [];
      devices.forEach((element) => deviceHolder.add(DeviceCountHolder(
          element.id, element.clientId, !element.inActiveLast72())));
      DateTime date = DateTime.now();
      counts.add(DeviceCount(
          formatDate2(DateTime(date.year, date.month, date.day)),
          deviceHolder
              .where((element) => element.clientId == widget.clientId)
              .toList()));

      for (int i = 0;
          DateTime(date.year, date.month, date.day - i)
              .isAfter(DateTime.utc(2021, 10, 24));
          i++) {
        history
            .where((history) => history.date.isAtSameMomentAs(
                DateTime(date.year, date.month, date.day - i)))
            .toList()
            .forEach((history) {
          String clientId = deviceHolder[deviceHolder
                  .indexWhere((element) => element.id == history.deviceId)]
              .clientId;
          deviceHolder[deviceHolder
                  .indexWhere((element) => element.id == history.deviceId)] =
              DeviceCountHolder(
                  history.deviceId, clientId, !history.active.contains("1"));
        });
        if (i > 0) {
          counts.add(DeviceCount(
              formatDate2(DateTime(date.year, date.month, date.day - i)),
              deviceHolder
                  .where((element) => element.clientId == widget.clientId)
                  .toList()));
        }
      }

      resNum = counts.length.toString();
      if (spans[0] != Span.up) {
        counts.sort((a, b) => b.getE(0).compareTo(a.getE(0)));
        spans[0] = Span.up;
        for (int i = 1; i < spans.length; i++) {
          spans[i] = Span.def;
        }
      }
      _pagingController.itemList = counts;
    } catch (error) {
      _pagingController.error = error;
      print(error);
    }
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
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: DeviceCountAppBar(
            context,
            parseClient(widget.clientId),
            displayAll,
            selectDay,
            selectMonth,
            exportPdf,
          ),
          preferredSize: const Size.fromHeight(50),
        ),
        body: Column(
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
                  hintText: "Enter date or a value",
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
                            width: 90,
                            height: 30,
                            title: "Date",
                            span: spans[0],
                            func: setSpans,
                            border: true,
                            index: 0,
                          ),
                          TitleElement(
                              // width: 70,
                              height: 30,
                              title: "Total",
                              span: spans[1],
                              border: true,
                              textSize: 12,
                              func: setSpans,
                              index: 1),
                          TitleElement(
                              // width: 70,
                              height: 30,
                              title: "Active",
                              span: spans[2],
                              func: setSpans,
                              textSize: 12,
                              border: true,
                              index: 2),
                          TitleElement(
                              // width: 70,
                              height: 30,
                              title: "Inactive",
                              span: spans[3],
                              textSize: 12,
                              func: setSpans,
                              index: 3),
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
                                () => refresh(),
                              ),
                              notificationPredicate:
                                  (ScrollNotification notification) {
                                return true;
                              },
                              child: PagedListView<int, DeviceCount>(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                pagingController: _pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<DeviceCount>(
                                  animateTransitions: true,
                                  firstPageErrorIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  newPageErrorIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  firstPageProgressIndicatorBuilder: (_) {
                                    return SizedBox();
                                  },
                                  newPageProgressIndicatorBuilder: (_) {
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
                                        // right: BorderSide(
                                        //     width: 1.0,
                                        //     color: Colors.grey),
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.grey),
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
                                            width: 90,
                                            title: formatDate2(DateTime.now())==item.date?"Today":item.date,
                                            high: item.highLight,
                                            border: true),
                                        Value(
                                            height: 30,
                                            // width: 71,
                                            title: item.total,
                                            high: item.highLight,
                                            onClick:()=>  Navigator.push(
                                              context,
                                              SizeRoute(
                                                page: DisplayDevice(widget.clientId,getDevices(item.deviceHolder),0,item.date),
                                              ),
                                            ),
                                            border: true),
                                        Value(
                                            height: 30,
                                            // width: 71,
                                            title: item.active,
                                            high: item.highLight,
                                            onClick: ()=>  Navigator.push(
                                              context,
                                              SizeRoute(
                                                  page: DisplayDevice(widget.clientId,getDevices(item.deviceHolder.where((element) => element.isActive).toList()),1,item.date),
                                              ),
                                            ),
                                            border: true),
                                        Value(
                                            height: 30,
                                            // width: 71,
                                            title: item.inactive,
                                            high: item.highLight,
                                            onClick:()=>  Navigator.push(
                                              context,
                                              SizeRoute(
                                                  page:  DisplayDevice(widget.clientId,getDevices(item.deviceHolder.where((element) => !element.isActive).toList()),2,item.date),
                                              ),
                                            ),
                                            border: false),
                                      ],
                                    ),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void progress(bool load) {
    setState(() {
      this.loading = load;
    });
  }

  Future<void> exportPdf() async {
    if (loading) {
    toast("Loading, Please be patient!");
      return;
    }

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

        grid.columns.add(count: 4);
        grid.headers.add(1);

        PdfGridRow header = grid.headers[0];
        header.cells[0].value = 'Date';
        header.cells[1].value = 'Total Devices';
        header.cells[2].value = 'Active Devices';
        header.cells[3].value = 'Inactive Devices';

        for (int i = 0; i < 4; i++) {
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
          row.cells[0].value = _pagingController.itemList[i].date;
          row.cells[1].value =
              _pagingController.itemList[i].deviceHolder.length.toString();
          row.cells[2].value =
              _pagingController.itemList[i].deviceHolder.where((element) => element.isActive).length.toString();
          row.cells[3].value =
              _pagingController.itemList[i].deviceHolder.where((element) => !element.isActive).length.toString();

          for (int l = 0; l < 4; l++) {
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
                    40, 40, width - 40, height - (size.height +30))),
            bounds: Rect.fromLTWH(
                40,
                (width / 7) + 60 + size4.height,
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

        graphics.drawString('Client: ' + compress(parseClient(widget.clientId)), fontTitle,
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

        saveAndLaunchFile(document, parseClient(widget.clientId) + '.pdf');
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

  Future<void> displayAll() async {
    selectedDay = DateTime.now();
    selectedMonth = DateTime.now();
    searchController.clear();
    setState(() {
      validate = false;
      if (spans[0] != Span.up) {
        counts.sort((a, b) => b.getE(0).compareTo(a.getE(0)));
        spans[0] = Span.up;
        for (int i = 1; i < spans.length; i++) {
          spans[i] = Span.def;
        }
      }
      counts.forEach((element) => element.setHighLight(''));
      _pagingController.itemList = counts;
      resNum = counts.length.toString();
    });
  }

  Future<void> selectDay() async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2021,10,25),
      lastDate: DateTime.now(),
      fieldHintText: "Select Day",
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(0xff0065a3, customColors),
              primaryColorDark: Color(0xff0065a3),
              accentColor: Color(0xff0065a3),
            ),
            dialogBackgroundColor: Colors.white,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          child: child,
        );
      },
    );

    if (pickedDate != null) {
      selectedDay = pickedDate;
      setState(() {
        _pagingController.itemList = counts.where((element) => element.date==formatDate2(pickedDate)).toList();
        resNum = _pagingController.itemList.length.toString();
      });
    }
  }

  Future<void> selectMonth() async {
    final DateTime pickedDate = await showMonthPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2021, 10, 25),
      lastDate: DateTime.now(),
      locale: Locale("en"),
    );
    if (pickedDate != null) {
      selectedMonth = pickedDate;
      setState(() {
        _pagingController.itemList = counts.where((element) => DateTime(DateFormat('yyyy-MM-dd').parse(element.date.trim()).year,DateFormat('yyyy-MM-dd').parse(element.date.trim()).month).isAtSameMomentAs(DateTime(pickedDate.year,pickedDate.month))).toList();
        resNum = _pagingController.itemList.length.toString();
      });
    }
  }

String compress(String str) {
  try {
    str = client[int.parse(str) - 1].value;
  } catch (error) {}
  if (str.toLowerCase().contains("research & development department")) {
    return "R&D";
  } else if (str.toLowerCase().contains("comdelta technologies")) {
    return "Comdelta";
  } else if (str.length > 11) {
    return str.substring(0, 11) + "...";
  } else {
    return str;
  }
}

Future<String> getDirectoryPath() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();

  Directory directory =
  await new Directory(appDocDirectory.path + '/' + 'dir')
      .create(recursive: true);

  return directory.path;
}

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

    List<DeviceJason> getDevices(List<DeviceCountHolder> devicesCount){
      List<DeviceJason> temp=[];
      devicesCount.forEach((deviceCount) {
        DeviceJason device = devices.firstWhere((device) => deviceCount.id==device.id);
        if(device!=null){
          temp.add(device);
        }
      });
        return temp;
    }
}
