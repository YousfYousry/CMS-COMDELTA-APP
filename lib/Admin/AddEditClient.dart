import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Widgets/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/SizeTransition.dart';

// const PrimaryColor = const Color(0xff0065a3);

String title="Add Client";
class AddClient extends StatefulWidget {
  AddClient({title});

  @override
  _AddClient createState() => _AddClient();
}

class _AddClient extends State<AddClient> {
  bool loading = true;

  // var clients = List<DeviceElement>();

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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBarBack(context, title),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, SizeRoute(page: DashBoard()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.indigoAccent,
        ),

        // drawer: SideDrawerAdmin(),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (text) {
                      // filterSearchResults(text);
                    },
                    // controller: searchController,
                    decoration: InputDecoration(
                      // errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(20.0),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Slidable(
                        // delegate: new SlidableDrawerDelegate(),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Container(
                          height: 70,
                          color: Colors.white,
                          child: new ListTile(
                            leading: new CircleAvatar(
                              // radius: 25,
                              backgroundColor: Colors.indigoAccent,
                              child: new Text('D'),
                              foregroundColor: Colors.white,
                            ),
                            title:  Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: new Text('DHarmoni'),
                            ),
                            subtitle: new Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Icon(Icons.email, size: 14),
                                    ),
                                    Text('dharmoni@comdelta.com'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Icon(Icons.phone, size: 14),
                                    ),
                                    Text('0138765679'),
                                  ],
                                ),
                              ],
                            ),
                            // new Column(
                            //   children: [
                            //     new Text('SlidableDrawerDelegate'),
                            //     new Text('SlidableDrawerDelegate'),
                            //   ],
                            // ),
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

                  // child: ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: 300,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return InkWell(
                  //       onTap: () {},
                  //       child: clientElement(
                  //         context: context,
                  //         index: index,
                  //         ID: "5",
                  //         Details: "5",
                  //         Location: "5",
                  //         HighLight: "5",
                  //       ),
                  //     );
                  //   },
                  // ),
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

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}
