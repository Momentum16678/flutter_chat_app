import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/chat_bubble.dart';
import 'package:flutter_chat_app/chat_service.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:nb_utils/nb_utils.dart';

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
        title: Text(widget.receiverEmail, style: const TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.w700,
            //fontFamily: StringManager.dmSans,
            fontSize: 15,
        ),),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
              onTap: () {
                pop();
              },
              child: Image.asset('assets/images/back_arrow.png', height: 5, width: 5)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: chatBodyColor,
      ),
      backgroundColor: chatBodyColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //messages
            Expanded(child: _buildMessageList()),

            //userInput
            _buildMessageInput(),

            const SizedBox(height: 20,)
          ],
        ),
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
            return const Center(child:  CircularProgressIndicator());
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
          const SizedBox(height: 5,),
          ChatBubble(message: data['message'], color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? Colors.white
              : chatColor,),
          const SizedBox(height: 5,),
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: TextField(
                controller: messageController,
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "Type Something...",
                    hintStyle: TextStyle(
                        color: mainTextColor.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        //fontFamily: StringManager.dmSans,
                        fontSize: 14,
                        fontStyle: FontStyle.italic
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                      borderSide: BorderSide.none,),
                    filled: true,
                    fillColor: Colors.white
                )
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 21.5),
                decoration: const BoxDecoration(
                    color: primaryColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                ),
                child: Center(child: GestureDetector(onTap: sendMessage, child: Image.asset(sendIcon, height: 25, width: 25,)))),
          )
        ],
      ),
    );
  }
}
