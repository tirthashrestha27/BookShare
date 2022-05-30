// import 'package:bool_chain_v2/screens/ad_screen.dart';
import 'package:bool_chain_v2/screens/everyBook.dart';
import 'package:bool_chain_v2/services/ad_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bool_chain_v2/screen_body/top_app_bar.dart';
import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// BannerAd bannerAd;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ams = AdManager();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);

    AdManager.show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(child: Navigation()),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              TopAppBar1(),
            ];
          },
          body: TabBarView(children: [
            Container(
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
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        child: GestureDetector(
                                            child: Hero(
                                                tag: document.documentID,
                                                child: Image.network(
                                                  document['image'],
                                                )),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                // BuildContext context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EverybookInfo(
                                                          document.documentID),
                                                ),
                                              );
                                            }),
                                      )),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(7.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document["bookName"],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
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
                                              Text(
                                                "Rating",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  RatingBar.builder(
                                                    onRatingUpdate: null,
                                                    ignoreGestures: true,
                                                    initialRating:
                                                        document['bookRating'],
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 25,
                                                    itemBuilder:
                                                        (context, snapshot) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
            ),
            Container()
          ]),
        ),
      ),
    );
  }
}
