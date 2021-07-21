// import 'dart:convert';
import 'dart:convert';
import 'dart:ui';
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
  bool loading = true,validate=false;

  var clients = [];
  var duplicateClients = [];

  void filterSearchResults(String query) {
    bool resultFound=false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateClients);
    if (query.isNotEmpty) {
      var dummyListData = [];
      dummySearchList.forEach((client) {
        if (client.clientName.toLowerCase().contains(query.toLowerCase()) ||
            client
                .clientContact
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            client.clientEmail.toLowerCase().contains(query.toLowerCase())) {
          resultFound=true;
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
                        // delegate: new SlidableDrawerDelegate(),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Container(
                          height: 80,
                          child: new ListTile(
                            leading: new CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xff0065a3),
                              child: new Text(clients[index].clientName[0]),
                              foregroundColor: Colors.white,
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(top: 13),
                              child:
                              SubstringHighlight(
                                text: clients[index].clientName,
                                term: clients[index].highLight,
                                textStyleHighlight: TextStyle(fontSize: 16,color: Colors.red, fontWeight: FontWeight.bold,
                                ),
                                textStyle: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
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
                                            color: Colors.black54, size: 13),
                                      ),

                                      SubstringHighlight(
                                        text: clients[index].clientEmail,
                                        term: clients[index].highLight,
                                        textStyleHighlight: TextStyle(fontSize: 14,color: Colors.red, fontWeight: FontWeight.bold,
                                        ),
                                        textStyle: TextStyle(fontSize: 14,color: Colors.black54,),
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
                                            color: Colors.black54, size: 13),
                                      ),

                                      SubstringHighlight(
                                        text: clients[index].clientContact,
                                        term: clients[index].highLight,
                                        textStyleHighlight: TextStyle(fontSize: 14,color: Colors.red, fontWeight: FontWeight.bold,
                                        ),
                                        textStyle: TextStyle(fontSize: 14,color: Colors.black54,),
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
                        // actions: <Widget>[
                        //   new IconSlideAction(
                        //     caption: 'Archive',
                        //     color: Colors.blue,
                        //     icon: Icons.archive,
                        //     onTap: () => toast('Archive'),
                        //   ),
                        //   new IconSlideAction(
                        //     caption: 'Share',
                        //     color: Colors.indigo,
                        //     icon: Icons.share,
                        //     onTap: () => toast('Share'),
                        //   ),
                        // ],
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Edit',
                            color: Colors.black45,
                            icon: Icons.edit,
                            onTap: () => toast('More'),
                          ),
                          new IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => toast('Delete'),
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
