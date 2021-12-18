import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/Widgets/Cards/ShowDevice.dart';
import 'package:login_cms_comdelta/Widgets/Functions/ExportExcel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Pages/DeviceLogs.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DisplayDevicesAppBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../public.dart';

class DisplayDevice extends StatefulWidget {
  final clientId;
  final devices;
  final status;
  final date;

  DisplayDevice(this.clientId,this.devices, this.status,this.date);

  @override
  _DisplayDevice createState() => _DisplayDevice();
}

class _DisplayDevice extends State<DisplayDevice> {
  TextEditingController searchController = new TextEditingController();
  bool loading = false, validate = false;
  int sortState = 1;
  Snack deleteSnack;
  String resNum = "0";

  var spans = [Span.up, Span.def, Span.def];

  final PagingController<int, DeviceJason> _pagingController =
      PagingController(firstPageKey: 0);

  List<DeviceJason> duplicateDevices = [];

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
        // devices.clear();
        _pagingController.itemList = dummyListData;
      });
      return;
    } else {
      setState(() {
        validate = false;
        spans[0] = Span.up;
        spans[1] = Span.def;
        spans[2] = Span.def;
        duplicateDevices.forEach((element) => element.setHighLight(''));
        _pagingController.itemList = duplicateDevices;
        resNum = duplicateDevices.length.toString();
      });
    }
  }

  @override
  void initState() {
    this.duplicateDevices = widget.devices;
    setState(() {
      this._pagingController.itemList = widget.devices;
      resNum = widget.devices.length.toString();
      sort();
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deleteSnack = new Snack(this.context, "Deleting...", 100);
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
          child: DisplayDevicesAppBar(
            context,
            getBarTitle(),
            exportPDF,
            exportExcel,
          ),
          preferredSize: const Size.fromHeight(50),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context, SizeRoute(page: AddClient()));
        //   },
        //   child: const Icon(Icons.add),
        //   backgroundColor: Color(0xff0065a3),
        // ),
        // drawer: SideDrawerAdmin(),
        // resizeToAvoidBottomInset: false,
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
                  hintText: "Enter ID or Name or Location",
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
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
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
                                        TextSpan(text: 'Device Name'),
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
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: new BoxDecoration(color: Colors.white),
                        child: Stack(
                          children: [
                            RefreshIndicator(
                              onRefresh: () => Future.sync(
                                () => allDevices(),
                              ),
                              child: PagedListView<int, DeviceJason>(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                pagingController: _pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<DeviceJason>(
                                  firstPageErrorIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  newPageErrorIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  firstPageProgressIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  newPageProgressIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  noMoreItemsIndicatorBuilder: (_) =>
                                      SizedBox(),
                                  animateTransitions: true,
                                  itemBuilder: (context, item, index) =>
                                      Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.20,
                                    child: new Column(
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
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
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: SubstringHighlight(
                                                        text:
                                                            item.deviceLocation,
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
                                    actions: [
                                      new IconSlideAction(
                                        caption: 'Logs',
                                        color: Color(0xffFFB61E),
                                        icon: Icons.signal_cellular_alt,
                                        onTap: () => deviceLogs(item),
                                      ),
                                      new IconSlideAction(
                                        caption: 'Download',
                                        color: Colors.green,
                                        icon: Icons.download,
                                        onTap: () => downloadLogs(item.id),
                                      ),
                                    ],
                                    secondaryActions: <Widget>[
                                      new IconSlideAction(
                                        caption: 'Edit',
                                        color: Color(0xff62D0F1),
                                        icon: Icons.edit,
                                        onTap: () => editDevice(item),
                                      ),
                                      new IconSlideAction(
                                        caption: 'Delete',
                                        color: Color(0xffE5343D),
                                        icon: Icons.delete,
                                        onTap: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.WARNING,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title: 'Delete Device',
                                            desc:
                                                'Do you really want to delete ' +
                                                    item.deviceName,
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              deleteSnack.show();
                                              sendDeleteReq(item.id);
                                            },
                                          )..show();
                                        },
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
                      ),
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

  void editDevice(DeviceJason deviceJason) {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Edit Device", deviceJason),
      ),
    ).then((value) => allDevices());
  }

  void addDevice() {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Add Device", null),
      ),
    ).then((value) => allDevices());
  }

  void deviceLogs(DeviceJason device) {
    Navigator.push(
      context,
      SizeRoute(
        page: DeviceLogs(device),
      ),
    );
  }

  Future<void> exportPDF() async {
    if (loading) {
      toast("Loading, Please be patient!");
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

        String title = compress(parseClient(widget.clientId))+", "+getPDFDate();

        String text =
            'This is a computer-generated document. No signature is required.\nContact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898';
        Size size = font.measureString(text);
        Size size1 = font.measureString(
            'Contact Us: info@comdelta.com.my | www.comdelta.com.my | +603-83228898');
        Size size2 = font.measureString('Contact Us: ');
        Size size3 = font.measureString('Contact Us: info@comdelta.com.my |');
        Size size4 =
            fontTitle.measureString(title);
        Size size5 = fontGridTitle.measureString('No.');

        PdfPage page = document.pages.add();
        PdfGraphics graphics = page.graphics;
        double width = graphics.clientSize.width,
            height = graphics.clientSize.height;

        PdfGrid grid = PdfGrid();
        grid.style = PdfGridStyle(
            font: fontGrid,
            cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

        grid.columns.add(count: 9);
        grid.headers.add(1);

        PdfGridRow header = grid.headers[0];
        header.cells[0].value = 'No.';
        header.cells[1].value = 'Device Name';
        header.cells[2].value = 'Site Details';
        header.cells[3].value = 'Location';
        header.cells[4].value = 'Height';
        header.cells[5].value = 'Sim serial no';
        header.cells[6].value = 'Sim provider';
        header.cells[7].value = 'Batch no.';
        header.cells[8].value = 'Activation date';

        for (int i = 0; i < 9; i++) {
          header.cells[i].style = PdfGridCellStyle(
              font: fontGridTitle,
              cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
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
          row.cells[0].value = _pagingController.itemList[i].id;
          row.cells[1].value = _pagingController.itemList[i].deviceName;
          row.cells[2].value = _pagingController.itemList[i].deviceDetails;
          row.cells[3].value = _pagingController.itemList[i].deviceLocation;
          row.cells[4].value = _pagingController.itemList[i].deviceHeight;
          row.cells[5].value = _pagingController.itemList[i].serialNum;
          row.cells[6].value = _pagingController.itemList[i].simProvider;
          row.cells[7].value = _pagingController.itemList[i].batchNum;
          row.cells[8].value = _pagingController.itemList[i].activationDate;

          for (int l = 0; l < 9; l++) {
            if (i % 2 != 0) {
              row.cells[l].style = PdfGridCellStyle(
                  font: fontGrid,
                  cellPadding:
                      PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
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
            bounds: Rect.fromLTWH(40, 40 + width / 7 + 10 + size4.height + 10,
                width - 40, height - (size.height + 30)));

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

        graphics.drawString(
          title,
          fontTitle,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(40, 40 + width / 7 + 10, 0, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
          ),
        );

        graphics.drawString(
          'Date of generated: ' +
              DateFormat('dd MMM yyyy').format(DateTime.now()),
          font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(width - 40, 40 + width / 7 + 10, 0, 0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
          ),
        );

        saveAndLaunchFile(document, 'Device List.pdf');
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

  Future<void> downloadLogs(String id) async {
    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        toast('Downloading');
        progressBar(true);
        http.post(
            Uri.parse(
                'http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
            body: {
              'device_id': id,
            }).then((value) {
          if (value.statusCode == 200) {
            List<LogJason> logs = [];
            List<dynamic> values = [];
            values = json.decode(value.body);

            if (values.length > 0) {
              for (int i = 0; i < values.length; i++) {
                if (values[i] != null) {
                  Map<String, dynamic> map = values[i];
                  logs.add(LogJason.fromJson(map, ""));
                }
              }
            }
            ExportExcel(id, logs, progressBar);
          } else {
            progressBar(false);
            throw Exception("Unable to get Log list");
          }
        }).onError((error, stackTrace) {
          progressBar(false);
          toast('Error: ' + error.message);
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

  Future<void> exportExcel() async {
    if (loading) {
      toast("Loading, Please be patient!");
      return;
    }

    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        ExportExcel("Device List", _pagingController.itemList, progressBar);
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

  void progressBar(bool loading) {
    setState(() {
      this.loading = loading;
    });
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

  void sendDeleteReq(String deviceId) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/deleteDevice.php'),
        body: {
          'device_id': deviceId,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        if (body == '0') {
          toast("Device has been deleted successfully");
          allDevices();
        } else {
          toast("Something wrong with the server");
          print(body);
        }
      } else {
        toast("Something wrong with the server");
        print(response.body);
      }
      deleteSnack.hide();
      allDevices();
    }).onError((error, stackTrace) {
      deleteSnack.hide();
      allDevices();
      toast('Error: ' + error.message);
    });
  }

  void allDevices() {
    this.duplicateDevices = widget.devices;
    setState(() {
      this._pagingController.itemList = widget.devices;
      resNum = widget.devices.length.toString();
      sort();
    });
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

  String getPDFDate(){
    if(widget.status==0){
      return formatDate2(DateTime.now())==widget.date?"Total Devices Today":"Total Devices on "+widget.date;
    }else if(widget.status==1){
      return formatDate2(DateTime.now())==widget.date?"Active Devices Today":"Active Devices on "+widget.date;
    }else if(widget.status==2){
      return formatDate2(DateTime.now())==widget.date?"Inactive Devices Today":"Inactive Devices on "+widget.date;
    }else{
      return widget.date;
    }
  }

  String getBarTitle(){
    if(widget.status==0){
      return formatDate2(DateTime.now())==widget.date?"Total Today":"Total on "+widget.date;
    }else if(widget.status==1){
      return formatDate2(DateTime.now())==widget.date?"Active Today":"Active on "+widget.date;
    }else if(widget.status==2){
      return formatDate2(DateTime.now())==widget.date?"Inactive Today":"Inactive on "+widget.date;
    }else{
      return widget.date;
    }
  }

  int getInt(String s) {
    try {
      if (s == null || int.parse(s) == null) {
        return 0;
      }
      return int.parse(s);
    } catch (error) {
      return 0;
    }
  }
}
