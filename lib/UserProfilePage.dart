import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawer.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _text = TextEditingController();
  bool _validate = false;

  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: CustomeAppBar('User Profile'),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          height: 610,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO9PbsbTpb9HLsQKEUSnEM5bA5hFiR5rmekw&usqp=CAU'),
                  ),
                ),
                width: 340,
                height: 180,
                child: Container(
                  height: 100,
                  alignment: Alignment(0.0, 1.6),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/image/Avatar.jpeg',
                      height: 80.0,
                      width: 80.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'EDOTCO COMDELTA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                width: 330,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'First Name',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Second Name',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.name],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Email',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      // The validator receives the text that the user has entered.
                      autofillHints: [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Updating Profile'),
                            ),
                          );
                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Add TextFormFields and ElevatedButton here.
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
