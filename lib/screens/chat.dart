import 'package:bool_chain_v2/services/ad_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

FirebaseUser loggedInUser;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = FirebaseAuth.instance;
  final ams = AdManager();

  @override
  void initState() {
    super.initState();
    AdManager.hide();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('safal');
    AdManager.hide();
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
          title: Text('Chat Room'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: ChatStream(),
        ));
  }
}

class ChatStream extends StatelessWidget {
  const ChatStream({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('group')
            .orderBy('lastModified', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents;
          List<Message> messageBubbles = [];
          for (var message in messages) {
            if (message.data['member0'] == loggedInUser.uid ||
                message.data['member1'] == loggedInUser.uid) {
              List<String> names = List.from(message.data['recentMessage']);
              final messageID = message.data['id'];
              final messageText = names[0];
              final messageSender = message.data['senderID'];
              final currentUser = loggedInUser.uid;
              final messageSenderName = message.data['sender'];
              final messageBubble = Message(
                text: messageText,
                sender: messageSenderName,
                isMe: currentUser == messageSender,
                messageId: messageID,
              );
              messageBubbles.add(messageBubble);
            }
          }
          return ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            children: messageBubbles,
          );
        });
  }
}

class Message extends StatefulWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String messageId;
  Message({this.sender, this.text, this.isMe, this.messageId});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            // BuildContext context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                messageId: widget.messageId,
              ),
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.sender,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(widget.text),
            ),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
