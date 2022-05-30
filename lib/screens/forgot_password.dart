import 'package:flutter/material.dart';

import '../constants.dart' show kformDecoration;
import 'package:bool_chain_v2/services/firebase_auth_service.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;
  String _error;

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.blue,
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    decoration: kformDecoration.copyWith(
                      errorMaxLines: 1,
                      hintText: "Enter your email",
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context) => RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    child: Text('Send Password Reset link'),
                    onPressed: () async {
                      await _firebaseAuthService
                          .sendPasswordResetVerification(_email)
                          .then((value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Password Reset Link sent to email"),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              // Some code to undo the change.
                              Navigator.pop(context);
                            },
                          ),
                        ));
                      }).catchError((e) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Error: ${e.message}"),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        ));
                        print("hello $_error");
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
