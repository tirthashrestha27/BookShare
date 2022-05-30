import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'everyBook.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Wished Books"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(userUID)
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            if (snapshots.data['wishList'] == null) return Container();
            final list = snapshots.data['wishList'].toList();
            return Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('books').snapshots(),
                // ignore: missing_return
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView(
                            children: snapshot.data.documents.map((document) {
                              if (list.contains(document.documentID)) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(35.0),
                                        bottomRight: Radius.circular(35.0)),
                                  ),
                                  elevation: 8.0,
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.lightBlueAccent
                                          ]),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(35.0),
                                          bottomRight: Radius.circular(35.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Hero(
                                            tag: document.documentID,
                                            child: FlatButton(
                                                child: Image.network(
                                                    document['image']),
                                                onPressed: () {
                                                  var bookId =
                                                      document.documentID;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EverybookInfo(
                                                                bookId)),
                                                  );
                                                }),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(7.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  document["bookName"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text("Author",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                                Text(document['bookAuthor'],
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black)),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Center(
                                                  child: Tooltip(
                                                    message:
                                                        'Click if you have received the book',
                                                    child: FlatButton(
                                                      color: Colors.white,
                                                      child: Text(
                                                        "Book Received",
                                                        style: TextStyle(
                                                            fontSize: 11),
                                                      ),
                                                      onPressed: () async {
                                                        List<DocumentSnapshot>
                                                            documentList;
                                                        List f = new List();
                                                        f.add(userUID);
                                                        f.add(document[
                                                            'bookOwner']);
                                                        documentList =
                                                            (await Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'group')
                                                                    .where(
                                                                        'member0',
                                                                        whereIn:
                                                                            f)
                                                                    .getDocuments())
                                                                .documents;
                                                        documentList
                                                            .asMap()
                                                            .forEach(
                                                                (key, value) {
                                                          if (value.data[
                                                                      'member1'] ==
                                                                  f[0] ||
                                                              value.data[
                                                                      'member1'] ==
                                                                  f[1]) {
                                                            Firestore.instance
                                                                .collection(
                                                                    'group')
                                                                .document(value
                                                                    .documentID)
                                                                .delete();
                                                            Firestore.instance
                                                                .collection(
                                                                    'message')
                                                                .document(value
                                                                    .documentID)
                                                                .delete();
                                                          }
                                                        });
                                                        Firestore.instance
                                                            .collection('books')
                                                            .document(document
                                                                .documentID)
                                                            .updateData({
                                                          'bookOwner': userUID
                                                        });

                                                        Firestore.instance
                                                            .collection('users')
                                                            .document(userUID)
                                                            .updateData({
                                                          'wishList': FieldValue
                                                              .arrayRemove([
                                                            document.documentID
                                                          ])
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Tooltip(
                                                    message:
                                                        'Click if you want to cancel the book',
                                                    child: FlatButton(
                                                      color: Colors.white,
                                                      child: Text(
                                                        "Book Cancelled",
                                                        style: TextStyle(
                                                            fontSize: 11),
                                                      ),
                                                      onPressed: () async {
                                                        List<DocumentSnapshot>
                                                            documentList;
                                                        List f = new List();
                                                        f.add(userUID);
                                                        f.add(document[
                                                            'bookOwner']);
                                                        documentList =
                                                            (await Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'group')
                                                                    .where(
                                                                        'member0',
                                                                        whereIn:
                                                                            f)
                                                                    .getDocuments())
                                                                .documents;
                                                        documentList
                                                            .asMap()
                                                            .forEach(
                                                                (key, value) {
                                                          if (value.data[
                                                                      'member1'] ==
                                                                  f[0] ||
                                                              value.data[
                                                                      'member1'] ==
                                                                  f[1]) {
                                                            Firestore.instance
                                                                .collection(
                                                                    'group')
                                                                .document(value
                                                                    .documentID)
                                                                .delete();
                                                            Firestore.instance
                                                                .collection(
                                                                    'message')
                                                                .document(value
                                                                    .documentID)
                                                                .delete();
                                                            Firestore.instance
                                                                .collection(
                                                                    'users')
                                                                .document(
                                                                    userUID)
                                                                .updateData({
                                                              'wishList': FieldValue
                                                                  .arrayRemove([
                                                                document
                                                                    .documentID
                                                              ])
                                                            });
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else
                                return Center();
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
