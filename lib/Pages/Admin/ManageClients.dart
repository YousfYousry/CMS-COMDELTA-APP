import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_cms_comdelta/JasonHolders/ClientJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import 'package:http/http.dart' as http;
import 'package:substring_highlight/substring_highlight.dart';
import '../../main.dart';
import '../../public.dart';
import 'AddEditClient.dart';

class ManageClient extends StatefulWidget {
  @override
  _ManageClient createState() => _ManageClient();
}

class _ManageClient extends State<ManageClient> with WidgetsBindingObserver , RouteAware{
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;
  final pageAnimationDuration = const Duration(milliseconds: 300);

  var clients = [];
  var duplicateClients = [];
  Snack deleteSnack;

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

  GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(pageAnimationDuration, () {
      setState(() => _fabVisible = true);
    });
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
    elevation: 10,
    backgroundColor: Color(0xff0065a3),
    key: key,
    onPressed: () => _onFabTap(context),
    child: Icon(Icons.add),
  );

  _onFabTap(BuildContext context) {

    // Hide the FAB on transition start
    setState(() => _fabVisible = false);

    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: pageAnimationDuration,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          AddClient(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    )).then((value) => getClients());
  }

  Widget _buildTransition(
      Widget page,
      Animation<double> animation,
      Size fabSize,
      Offset fabOffset,
      ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }


  @override
  void initState() {
    getClients();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getClients();
    }
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
          child: CustomAppBarBack(context, "Manage Client"),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: Visibility(
          visible: _fabVisible,
          child: _buildFAB(context, key: _fabKey),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context, SizeRoute(page: AddClient()))
        //         .then((value) => getClients());
        //   },
        //   child: const Icon(Icons.add),
        //   backgroundColor: Color(0xff0065a3),
        // ),
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
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: (index == (clients.length - 1)) ? 70 : 0),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.17,
                          child: Container(
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
                                          details('Address',
                                              clients[index].clientAddress),
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
                                                  ? "Shown"
                                                  : "Hidden"),
                                          details(
                                              'Inactive Device',
                                              (clients[index]
                                                      .statThree
                                                      .toString()
                                                      .contains("1"))
                                                  ? "Shown"
                                                  : "Hidden"),
                                          status(
                                              'Status',
                                              clients[index]
                                                  .status
                                                  .toString()
                                                  .contains("1")),
                                          Row(
                                            children: [
                                              dialogButton(
                                                  Colors.black45,
                                                  "Edit",
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
                                              padding:
                                                  EdgeInsets.only(right: 5),
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
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(Icons.phone,
                                                  color: Colors.black54,
                                                  size: 13),
                                            ),

                                            SubstringHighlight(
                                              text:
                                                  clients[index].clientContact,
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
                        ),
                      );
                    },
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

  void editClient(ClientJason client) {
    Navigator.push(
      context,
      SizeRoute(
        page: AddClient(title: "Edit Client", client: client),
      ),
    ).then((value) => getClients());
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
      btnOkOnPress: () {
        deleteSnack.show();
        sendDeleteReq(client.clientName);
      },
    )..show();
  }

  void sendDeleteReq(String clientName) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/deleteClient.php'),
        body: {
          'client_name': clientName,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        if (body == '0') {
          toast("Client has been deleted successfully");
          getClients();
        } else {
          toast("Something wrong with the server");
          print(body);
        }
      } else {
        toast("Something wrong with the server");
        print(response.body);
      }
      deleteSnack.hide();
      getClients();
    }).onError((error, stackTrace) {
      deleteSnack.hide();
      getClients();
      toast('Error: ' + error.message);
    });
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
      this.duplicateClients.clear();
      this.clients.clear();
      this.duplicateClients.addAll(clients);
      this.clients.addAll(clients);
      loading = false;
    });
  }
}
