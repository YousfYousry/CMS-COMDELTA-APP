import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DeviceLogsAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Functions/ExportExcel.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../Choices.dart';

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

  List<LogJason> logs = [];
  List<LogJason> duplicateLogs = [];

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
          child: DeviceLogsAppBar(
              context,
              "Device " + widget.device.id + " Logs",
              showDeviceDetails,
              pdf,
              excel),
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

  Future<void> pdf() async {
    if (loading) {
      toast("Loading, please be patient");
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

        for (int i = 0; i < logs.length; i++) {
          row = grid.rows.add();
          row.cells[0].value = logs[i].createDate;
          row.cells[1].value = logs[i].ls1.contains("1") ? "ON" : "OFF";
          row.cells[2].value = logs[i].ls2.contains("1") ? "ON" : "OFF";
          row.cells[3].value = logs[i].ls3.contains("1") ? "ON" : "OFF";
          row.cells[4].value = logs[i].batteryValue;
          row.cells[5].value = logs[i].rssiValue;

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

        String str1 = 'Client: ' + clientCompressed[getInt(widget.device.client) - 1].value;
        String str2 = 'Device name: ' + widget.device.deviceName;
        String str3 = 'Height: ' + widget.device.deviceHeight;
        String str4 = 'Location: ' + widget.device.deviceLocation;

        String str5 = 'Site Details: ' +
            widget.device.deviceDetails;
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

        saveAndLaunchFile(document, widget.device.id.toString()+'.pdf');
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
    if (loading) {
      toast("Loading, please be patient");
      return;
    }

    await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        ExportExcel(widget.device.id,this.logs, (bool loading) {
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
    final String fileName =
    Platform.isWindows ? '$path\\'+name.toString() : '$path/'+name.toString();
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  void showDeviceDetails() {
    ShowDevice(context, widget.device);
  }
}
