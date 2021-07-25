// import 'dart:convert';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/JasonHolders/ClientJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:substring_highlight/substring_highlight.dart';

import 'AddEditClient.dart';

// const PrimaryColor = const Color(0xff0065a3);

class ManageClient extends StatefulWidget {
  @override
  _ManageClient createState() => _ManageClient();
}

class _ManageClient extends State<ManageClient> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;

  var clients = [];
  var duplicateClients = [];

  Widget details(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.6)),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget status(String title, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              value ? Icons.check : Icons.close,
              color: value ? Colors.green : Colors.red,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateClients);
    if (query.isNotEmpty) {
      var dummyListData = [];
      dummySearchList.forEach((client) {
        if (client.clientName.toLowerCase().contains(query.toLowerCase()) ||
            client.clientContact.toLowerCase().contains(query.toLowerCase()) ||
            client.clientEmail.toLowerCase().contains(query.toLowerCase())) {
          resultFound = true;
          client.setHighLight(query);
          dummyListData.add(client);
        }
      });
      setState(() {
        validate = !resultFound;
        clients.clear();
        clients.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        validate = false;
        // span1 = spanDown;
        // span2 = spanDefault;
        // span3 = spanDefault;
        clients.clear();
        clients.addAll(duplicateClients);
        clients.forEach((client) => client.setHighLight(''));
      });
    }
  }

  Widget dialogButton(Color btnColor, String title, Widget btnIcon,
      {VoidCallback onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(btnColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black12),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Container(
            height: 30,
            child: Row(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: btnIcon,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getClients();
    super.initState();
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
          child: CustomAppBarBack(context, "Manage Client"),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, SizeRoute(page: AddClient()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Color(0xff0065a3),
        ),

        // drawer: SideDrawerAdmin(),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 20, bottom: 5),
                  child: TextField(
                    onChanged: (text) {
                      filterSearchResults(text);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(15.0),
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
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.17,
                        child: new Container(
                          height: 80,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                AwesomeDialog(
                                  dialogBackgroundColor: Color(0xfafafafa),
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        details('ID', clients[index].id),
                                        details('Client Name',
                                            clients[index].clientName),
                                        details('Contact No',
                                            clients[index].clientContact),
                                        details('Email',
                                            clients[index].clientEmail),
                                        details('Created By',
                                            clients[index].createdBy),
                                        details('Created Date',
                                            clients[index].createdDate),
                                        details('Modified By',
                                            clients[index].modifiedBy),
                                        details('Modified Date',
                                            clients[index].modifiedDate),
                                        details(
                                            'Active Device',
                                            (clients[index]
                                                    .statTwo
                                                    .toString()
                                                    .contains("1"))
                                                ? "Hidden"
                                                : "Shown"),
                                        details(
                                            'Inactive Device',
                                            (clients[index]
                                                    .statThree
                                                    .toString()
                                                    .contains("1"))
                                                ? "Hidden"
                                                : "Shown"),
                                        status('Status', clients[index]
                                            .status
                                            .toString()
                                            .contains("1")),
                                        Row(
                                          children: [
                                            dialogButton(Colors.black45, "Edit",
                                                Icon(Icons.edit, size: 18),
                                                onPressed: () {
                                              Navigator.pop(context);
                                              editClient(clients[index]);
                                            }),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            dialogButton(Colors.red, "Delete",
                                                Icon(Icons.delete, size: 18),
                                                onPressed: () {
                                              Navigator.pop(context);
                                              deleteClient(
                                                  clients[index], context);
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                  // btnOkColor: Colors.red,
                                  // btnOkOnPress: (){},
                                  // btnOkIcon: Icons.delete,
                                  // btnOkText: "Delete",
                                  //
                                  // btnCancelColor: Colors.black45,
                                  // btnCancelOnPress: (){},
                                  // btnCancelIcon: Icons.edit,
                                  // btnCancelText: "Edit",
                                )..show();
                              },
                              child: ListTile(
                                leading: (clients[index]
                                            .clientLogo
                                            .toString()
                                            .trim()
                                            .isNotEmpty &&
                                        !clients[index]
                                            .clientLogo
                                            .toString()
                                            .contains("null"))
                                    ? new CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            "${clients[index].clientLogo}"),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : new CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Color(0xff0065a3),
                                        child: new Text(
                                            clients[index].clientName[0]),
                                        foregroundColor: Colors.white,
                                      ),
                                title: Padding(
                                  padding: EdgeInsets.only(top: 13),
                                  child: SubstringHighlight(
                                    text: clients[index].clientName,
                                    term: clients[index].highLight,
                                    textStyleHighlight: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  // new Text(
                                  //   clients[index].clientName,
                                  //   style: TextStyle(fontWeight: FontWeight.bold),
                                  // ),
                                ),
                                subtitle: new Column(
                                  children: [
                                    Visibility(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(Icons.email,
                                                color: Colors.black54,
                                                size: 13),
                                          ),

                                          SubstringHighlight(
                                            text: clients[index].clientEmail,
                                            term: clients[index].highLight,
                                            textStyleHighlight: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          // Text(clients[index].clientEmail),
                                        ],
                                      ),
                                      visible: clients[index]
                                          .clientEmail
                                          .toString()
                                          .isNotEmpty,
                                    ),
                                    Visibility(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(Icons.phone,
                                                color: Colors.black54,
                                                size: 13),
                                          ),

                                          SubstringHighlight(
                                            text: clients[index].clientContact,
                                            term: clients[index].highLight,
                                            textStyleHighlight: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          // Text(clients[index].clientContact),
                                        ],
                                      ),
                                      visible: clients[index]
                                          .clientContact
                                          .toString()
                                          .isNotEmpty,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: IconSlideAction(
                              caption: 'Edit',
                              color: Colors.black45,
                              icon: Icons.edit,
                              onTap: () => editClient(clients[index]),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () =>
                                  deleteClient(clients[index], context),
                            ),
                          ),
                        ],
                      );
                    },
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
        ),
      ),
    );
  }

  void editClient(ClientJason client) {
    Navigator.push(
      context,
      SizeRoute(
        page: AddClient(title: "Edit Client", client: client),
      ),
    );
  }

  void deleteClient(ClientJason client, context) {
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: Color(0xfafafafa),
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete Client',
      desc: 'Do you really want to delete ' + client.clientName,
      btnCancelColor: Colors.green,
      btnOkColor: Colors.red,
      btnOkIcon: Icons.delete,
      btnCancelIcon: Icons.cancel,
      btnOkText: "Delete",
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  void getClients() {
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/getClients.php')) // client_id	client_name	client_address	client_contact	client_email	client_logo	stat_three	stat_two	status	CreatedBy	CreatedDate	ModifiedBy	ModifiedDate
        .then((value) {
      if (value.statusCode == 200) {
        List<ClientJason> clients = [];
        List<dynamic> values = [];
        values = json.decode(value.body);

        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              clients.add(ClientJason.fromJson(map));
            }
          }
        }
        showClients(clients);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get Clients");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showClients(List<ClientJason> clients) {
    setState(() {
      this.duplicateClients.addAll(clients);
      this.clients.addAll(clients);
      loading = false;
    });
  }

  // void sendPost(String clientId, List<String> id, List<String> locationName) {
  //   http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/getDevice.php'),
  //       body: {
  //         'devices': 'active',
  //         'client_id': clientId,
  //       }).then((response) {
  //     if (response.statusCode == 200) {
  //       // ignore: deprecated_member_use
  //       List<DeviceElement> devices = new List<DeviceElement>();
  //       // ignore: deprecated_member_use
  //       List<dynamic> values = new List<dynamic>();
  //       values = json.decode(response.body);
  //       // print(values);
  //       if (values.length > 0) {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             devices.add(DeviceElement.fromJson(
  //                 map, (i + 1).toString(), id, locationName));
  //           }
  //         }
  //       }
  //       showDevices(devices);
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       throw Exception("Unable to get devices list");
  //     }
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     toast('Error: ' + error.message);
  //   });
  // }

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
}
