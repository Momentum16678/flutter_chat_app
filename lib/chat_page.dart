import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_bubble.dart';
import 'package:flutter_chat_app/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverUserId;

  const ChatPage(
      {Key? key, required this.receiverEmail, required this.receiverUserId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send if there is something to send
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, messageController.text);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(child: _buildMessageList()),

          //userInput
          _buildMessageInput(),

          const SizedBox(height: 20,)
        ],
      ),
    );
  }

  //build message list
  _buildMessageList(){
    return StreamBuilder(stream: _chatService.getMessages(
        widget.receiverUserId,
        _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
         if(snapshot.hasError){
           return Text('Error${snapshot.error}');
         }
         if(snapshot.connectionState == ConnectionState.waiting){
           return const Text('loading...');
         }

         return ListView(
           children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
         );

        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5,),
          ChatBubble(message: data['message'])
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey)))),
          IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
