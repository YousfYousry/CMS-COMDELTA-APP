import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Old information',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vaild email';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Email text field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Old Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct password';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Old Password',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Old Password field

              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'New information',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: 'New Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vaild passowrd';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'New Passowrd',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // New Password Field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Re-Type Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the same passowrd';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Re-Type Password',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // Re-Type Password Field
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 180,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Changing the password'),
                    ),
                  );
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Add TextFormFields and ElevatedButton here.
          ),
        ],
      ),
    );
  }
}
