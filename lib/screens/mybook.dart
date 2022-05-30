import 'package:bool_chain_v2/screen_body/navigation_sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'everyBook.dart';
import 'package:bool_chain_v2/services/firestorage.dart';

FireStorageService storageService = FireStorageService();

class MyBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Posted Books"),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: Firestore.instance.collection('books').snapshots(),
            // ignore: missing_return
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final messages = snapshot.data.documents;
              List<Message> messageBubbles = [];
              for (var message in messages) {
                if (userUID == message.data['bookOwner']) {
                  final bookName = message.data['bookName'];
                  final bookAuthor = message.data['bookAuthor'];
                  final bookImage = message.data['image'];
                  final bookId = message.documentID;
                  final messageBubble = Message(
                    booName: bookName,
                    bookAuthor: bookAuthor,
                    bookId: bookId,
                    bookImage: bookImage,
                  );
                  messageBubbles.add(messageBubble);
                }
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: false,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                      children: messageBubbles,
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

class Message extends StatefulWidget {
  final String booName;
  final String bookAuthor;
  final String bookId;
  final String bookImage;
  Message({this.booName, this.bookAuthor, this.bookId, this.bookImage});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0)),
      ),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.lightBlueAccent]),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(35.0),
              bottomRight: Radius.circular(35.0)),
        ),
        child: Row(
          children: [
            Expanded(
                child: Hero(
              tag: widget.bookId,
              child: FlatButton(
                  child: Image.network(widget.bookImage),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EverybookInfo(widget.bookId)),
                    );
                  }),
            )),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      widget.booName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Author",
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                    Text(widget.bookAuthor,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      color: Colors.white,
                      child: Text("Delete"),
                      onPressed: () async {
                        await Firestore.instance
                            .collection('books')
                            .document(widget.bookId)
                            .delete();
                        storageService.deletePhoto(widget.bookImage);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
