import 'package:flutter/material.dart';
import 'package:flutter_application_4/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_4/components/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'Chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

String MessageText = '';
final cloud = FirebaseFirestore.instance;
User? LoggedInUser;
var TimeStamp = null;

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final MessageController = TextEditingController();

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      LoggedInUser = user;
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(cloud: cloud),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: MessageController,
                      onChanged: (value) {
                        MessageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cloud.collection('Messages').add(
                        {
                          'Message': MessageText,
                          'UserID': LoggedInUser?.email,
                          'TimeStamp': FieldValue.serverTimestamp(),
                        },
                      );

                      MessageController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({required this.cloud});
  final FirebaseFirestore cloud;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: cloud.collection('Messages').orderBy('TimeStamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent),
          );
        }
        final Messages = snapshot.data!.docs.reversed;
        List<MessageBubble> MessageWidgets = [];
        for (var Message in Messages) {
          final messagetext = Message.get('Message');
          final messagesender = Message.get('UserID');
          final currentuser = LoggedInUser?.email;
          MessageBubble TextBubble = MessageBubble(
              sender: messagesender,
              text: messagetext,
              isMe: currentuser == messagesender);
          final messageWidget = TextBubble;
          MessageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: MessageWidgets,
          ),
        );
      },
    );
  }
}
