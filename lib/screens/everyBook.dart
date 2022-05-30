import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';

import 'package:bool_chain_v2/screens/chat_screen.dart';
import 'package:bool_chain_v2/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:bool_chain_v2/services/ad_manager.dart';
import 'package:bool_chain_v2/services/geolocation_service.dart';

var _bookStore = Firestore.instance;
var g;
var n;
var distance = 0.0;

class EverybookInfo extends StatelessWidget {
  final String bookId;
  EverybookInfo(this.bookId);

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<FirebaseAuthService>(context);
    GeoLocationService locationService = GeoLocationService();
    void getuserID() async {
      var h = await a.getCurrentUser();
      g = h.uid;
      n = h.email;
      print(n);
      print(g);
    }

    Future<void> location(String co) async {
      GeoPoint f1 = (await _bookStore.collection('users').document(g).get())
          .data["userGeoCode"];
      GeoPoint f2 = (await _bookStore.collection('users').document(co).get())
          .data["userGeoCode"];
      distance = await locationService.distanceBetweenCoordintaes(f1, f2);
      print('edjfkf');
      print(co);
      print(distance);
    }

    getuserID();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text("Book Info")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _bookStore.collection("books").document(bookId).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final Timestamp timestamp = snapshot.data['time'] as Timestamp;
          final DateTime dateTime = timestamp.toDate();
          final date = [dateTime.day, dateTime.month, dateTime.year];
          final bookOwner = snapshot.data['bookOwner'];
          final genres = snapshot.data['genres'];
          print(genres);

          return SingleChildScrollView(
              child: SafeArea(
            child: Column(
              children: [
                Hero(
                  tag: bookId,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data["image"]),
                          fit: BoxFit.scaleDown),
                      color: Colors.teal[100 * (1 % 9)],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                              children: [
                                Text("Posted on : "),
                                Text(date[2].toString() +
                                    " / " +
                                    date[1].toString() +
                                    " / " +
                                    date[0].toString())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: (bookOwner != g)
                                ? FlatButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "Talk",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      var check = 0;
                                      await _bookStore
                                          .collection('users')
                                          .document(g)
                                          .get()
                                          .then((value) => check =
                                              value.data['wishList'] == null
                                                  ? 0
                                                  : value
                                                      .data['wishList'].length);
                                      var id = '2';
                                      // int exist;
                                      List<DocumentSnapshot> documentList;
                                      List f = new List();
                                      f.add(g);
                                      f.add(snapshot.data['bookOwner']);
                                      print('members ${f[0]}  and ${f[1]}');
                                      print(snapshot.data['bookOwner']);
                                      documentList = (await _bookStore
                                              .collection('group')
                                              .where('member0', whereIn: f)
                                              .getDocuments())
                                          .documents;
                                      print(userUID);

                                      documentList
                                          .asMap()
                                          .forEach((key, value) {
                                        if (value.data['member1'] == f[0] ||
                                            value.data['member1'] == f[1]) {
                                          id = value.documentID;
                                        }
                                      });

                                      if (id != '2') {
                                        Navigator.of(context)
                                            .push(
                                              // BuildContext context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  messageId: id,
                                                ),
                                              ),
                                            )
                                            .then((value) => AdManager.show());
                                      }

                                      if (check < 3) {
                                        if (id == '2') {
                                          await _bookStore
                                              .collection('group')
                                              .add({
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
                                            'lastModified':
                                                FieldValue.serverTimestamp(),
                                            'member0':
                                                snapshot.data['bookOwner'],
                                            'member1': g,
                                            'recentMessage': [
                                              'Hello! Can we talk about "📘${snapshot.data['bookName']}" you uploaded?',
                                              g
                                            ],
                                            'senderID': g,
                                            'sender': n,
                                            'seen': 0
                                          }).then((value) {
                                            print('safal');
                                            id = value.documentID;
                                          });
                                          await _bookStore
                                              .collection('group')
                                              .document(id)
                                              .updateData({'id': id});
                                          await _bookStore
                                              .collection('message')
                                              .document(id)
                                              .collection('messages')
                                              .add({
                                            'text':
                                                'Hello!Can we talk about "📘${snapshot.data['bookName']}"  you uploaded?',
                                            'senderID': g,
                                            'sender': n,
                                            'time':
                                                FieldValue.serverTimestamp(),
                                            'seen': 0
                                          });
                                          await _bookStore
                                              .collection('users')
                                              .document(g)
                                              .updateData({
                                            'noOfBookRequesting':
                                                FieldValue.increment(1),
                                            'wishList': FieldValue.arrayUnion(
                                                [snapshot.data.documentID])
                                          });
                                          Navigator.of(context)
                                              .push(
                                                // BuildContext context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    messageId: id,
                                                  ),
                                                ),
                                              )
                                              .then(
                                                  (value) => AdManager.show());
                                        }
                                      } else {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                'You have reached the limit of 5 books')));
                                      }
                                      print(id);
                                    },
                                  )
                                : Text(' '),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: <Widget>[
                        for (var ip in genres)
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '  $ip  ',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ]),
                          ),
                      ],
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.book),
                            title: Text(
                              'Book Name',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text("${snapshot.data['bookName']}"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.book),
                            title: Text(
                              'Book Description',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle:
                                Text("${snapshot.data['bookDescription']}"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              'Book Author',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text("${snapshot.data['bookAuthor']}"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.star_border),
                            title: Text(
                              'Rating',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating: snapshot.data['bookRating'],
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemBuilder: (context, snapshot) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {
                                    print(value);
                                  },
                                ),
                                Text(
                                  snapshot.data["bookRating"].toString(),
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (bookOwner != g) ...[
                      FutureBuilder(
                          future: location(bookOwner),
                          builder: (context, snapshot) {
                            return Builder(
                              builder: (context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '$distance km away',
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
