import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'navigation_sidebar.dart';

final _firestore = Firestore.instance;
var id;

class UserInformation extends StatefulWidget {
  UserInformation(userUID);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // resizeToAvoridBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("User Information"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream:
                _firestore.collection("users").document(userUID).snapshots(),

            // ignore: missing_return
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              id = snapshot.data['userId'];
              GeoPoint position = snapshot.data["userGeoCode"];
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 95,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${snapshot.data["image"]}"),
                          radius: 90,
                          backgroundColor: Colors.transparent,
                        ),
                      )),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text(
                            "User Name",
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${snapshot.data['userName']}"),
                              Tooltip(
                                message: 'Edit User Name',
                                child: IconButton(
                                    iconSize: 15,
                                    icon: Icon(Icons.mode_edit),
                                    onPressed: () {
                                      showBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Wrap(
                                              children: [
                                                EditName(),
                                              ],
                                            );
                                          });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.broken_image),
                          title: Text(
                            'User Bio',
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text("${snapshot.data['userBio']}"),
                          trailing: Tooltip(
                            message: 'Edit your bio',
                            child: IconButton(
                              iconSize: 15,
                              icon: Icon(
                                Icons.mode_edit,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(children: [EditBio()]);
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(
                            'User Location',
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text("${snapshot.data['userAddress']}"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(
                            'User GeoCode',
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                              "${position.latitude},${position.longitude}"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class EditName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var newUserName;

    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Center(
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, backgroundColor: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  hintText: "Enter your new name",
                ),
                onChanged: (value) {
                  newUserName = value;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () {
                    _firestore
                        .collection('users')
                        .document(id)
                        .updateData({'userName': newUserName});
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Discard',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}

class EditBio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userBio;
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        // height: 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextField(
                maxLines: null,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, backgroundColor: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  hintText: "Enter your Bio",
                ),
                onChanged: (value) {
                  userBio = value;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () {
                    _firestore
                        .collection('users')
                        .document(id)
                        .updateData({'userBio': userBio});
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Discard',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
