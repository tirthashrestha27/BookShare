import 'package:bool_chain_v2/data/users.dart';
import 'package:bool_chain_v2/services/firebase_auth_service.dart';
import 'package:bool_chain_v2/services/firestorage.dart';
import 'package:bool_chain_v2/services/geolocation_service.dart';
import 'package:bool_chain_v2/services/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bool_chain_v2/services/firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final PageController _pageController = PageController();
  Users users = Users();
  GeoLocationService geoLocationService = GeoLocationService();
  String _password;
  String _address = "I don't know";
  TextEditingController emailInputController = TextEditingController();
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else if (value == null) {
      return 'Email cannot be empty';
    } else {
      return null;
    }
  }

  int _counter = 5;

  void _incrementCounter() {
    setState(() {
      _counter--;
    });
  }

  bool _error = false;
  bool _toggle = false;
  FireStorageService _storageService = FireStorageService();
  FirebaseAuthService _authService = FirebaseAuthService();
  FireStoreService _fireStoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageCapture>(
      create: (context) => ImageCapture(),
      child: Scaffold(
        body: SafeArea(
          child: Material(
              child: Consumer<ImageCapture>(builder: (context, image, child) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Book Share',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                inherit: false,
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autofocus: true,
                            style: TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.title),
                              hintText: 'Name',
                              labelText: ' Name',
                            ),
                            onSaved: (value) => users.userName = value,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            validator: (val) =>
                                val.isEmpty ? 'Name is required' : null,
                          ),
                          new TextFormField(
                            style: TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.email),
                              hintText: 'Email',
                              labelText: 'Email',
                            ),
                            controller: emailInputController,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => users.userEmail = value,
                            validator: emailValidator,
                          ),
                          TextFormField(
                            textAlign: TextAlign.justify,
                            maxLines: 1,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              icon: Icon(Icons.visibility_off),
                              hintText: 'Password',
                              labelText: 'Password',
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30)
                            ],
                            validator: (val) {
                              String msg;
                              if (val != _password) {
                                msg = 'Password do not match';
                              } else if (val.length <= 7)
                                msg =
                                    "Password must be longer than 7 character";
                              else
                                msg = null;
                              return msg;
                            },
                            onSaved: (value) => _password = value,
                          ),
                          TextFormField(
                              textAlign: TextAlign.justify,
                              maxLines: 1,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                icon: Icon(Icons.visibility_off),
                                hintText: 'Confirm Password',
                                labelText: 'Confirm Password',
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30)
                              ],
                              onSaved: (value) {
                                print(value);
                              },
                              validator: (val) {
                                String msg;
                                if (val != _password) {
                                  msg = 'Password do not match';
                                } else if (val.length <= 7)
                                  msg =
                                      "Password must be longer than 7 character";
                                else
                                  msg = null;
                                return msg;
                              }),
                          Container(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                                child: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    _pageController.animateToPage(1,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.linear);
                                    print('nani');
                                  }
                                }),
                          ),
                        ],
                      ),
                      ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          if (image.imageFile == null) ...[
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 140,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: () async {
                                        await image
                                            .pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          if (image.imageFile != null) ...[
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    child: CircleAvatar(
                                      radius: 65,
                                      backgroundImage:
                                          FileImage(image.imageFile),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: () async {
                                        await image
                                            .pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            textAlign: TextAlign.justify,
                            maxLines: null,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Short Description',
                              labelText: 'About User',
                            ),
                            onSaved: (value) => users.userBio = value,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500)
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // _error?Text('hello'):,
                              if (_error == false) ...[
                                Expanded(
                                  child: Text(
                                    '$_address',
                                  ),
                                )
                              ] else ...[
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      LinearProgressIndicator(),
                                    ],
                                  ),
                                )
                              ]
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 7),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                                child: Center(
                                    child: Text(
                                  'Get Location',
                                  textAlign: TextAlign.center,
                                )),
                                onPressed: () async {
                                  if (await geoLocationService
                                      .checkLocationService()) {
                                    setState(() {
                                      _error = true;
                                    });
                                    await Future.delayed(Duration(seconds: 1));
                                    await geoLocationService
                                        .getLocation()
                                        .then((value) async {
                                          Position position = value;
                                          print('k bhayo hamro samaye');
                                          print(value);

                                          users.position = position;
                                          users.userAddress =
                                              await geoLocationService
                                                  .getAddress(position);
                                          setState(() {
                                            _address = users.userAddress;
                                          });
                                        })
                                        .timeout(Duration(seconds: 5))
                                        .catchError((e) {
                                          setState(() {
                                            print("dame $e");
                                            _address =
                                                "Something went wrong.Try again later";
                                          });
                                        })
                                        .whenComplete(() {
                                          setState(() {
                                            _error = false;
                                          });
                                        });
                                  } else {
                                    setState(() {
                                      _address = 'Location service not enabled';
                                    });
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: _toggle,
                                  onChanged: (value) {
                                    setState(() {
                                      _toggle = !_toggle;
                                    });
                                  }),
                              Expanded(
                                child: Text(
                                  'I acccept the terms and conditions of BookChain',
                                  strutStyle: StrutStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                                child: Text('Register'),
                                onPressed: () async {
                                  if (users.userAddress == null) {
                                    setState(() {
                                      _address = "We need your address";
                                    });
                                  } else if (_toggle == false) {
                                    // print("dame");
                                  } else {
                                    await _authService
                                        .signUp(users.userEmail, _password)
                                        .then((value) async {
                                      users.userId = value;
                                      print(value);
                                      await _authService
                                          .sendEmailVerification();
                                      if (image.imageFile != null) {
                                        users.userProfilePicture =
                                            await _storageService.uploadUser(
                                                image: image.imageFile,
                                                name: DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString() +
                                                    users.userName
                                                        .substring(1));
                                      }
                                      _formKey.currentState.save();
                                      await _fireStoreService.addUser(users);
                                      _pageController.animateToPage(2,
                                          duration: Duration(milliseconds: 100),
                                          curve: Curves.bounceIn);
                                      _formKey.currentState.reset();
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      while (_counter > 0) {
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        _incrementCounter();
                                      }
                                      _authService.signOut();
                                      Navigator.pop(context);
                                    }).catchError((e) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Error: ${e.message}"),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                                      print("hello ");
                                    });
                                  }
                                }),
                          )
                        ],
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Thank you for creating your account',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              'Please verify your email to login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              'You will be redirected to login page in',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              '$_counter',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
        ),
      ),
    );
  }
}
