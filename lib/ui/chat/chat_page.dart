import 'package:chat_app/data/model/message_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  String userId;
  String uName;
  String uProfilePic;
  ChatPage({
    required this.userId,
    required this.uName,
    required this.uProfilePic,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel> listMsg = [];

  var msgController = TextEditingController();
  DateFormat dateFormat = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade800,
              child: Padding(
                padding: EdgeInsets.all(11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.grey),
                        ),

                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow.shade100,
                            backgroundImage:
                                widget.uProfilePic != ""
                                    ? NetworkImage(widget.uProfilePic!)
                                    : AssetImage(
                                      'assets/app_image/ic_user.png',
                                    ),
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          widget.uName,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.green.shade50)),
            SizedBox(height: 7),
            TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: msgController,
              enableSuggestions: true,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    FirebaseRepository.sendTextMessage(toId: widget.userId, msg: msgController.text);
                    msgController.clear();
                  },
                  child: Icon(Icons.send_rounded, color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.mic, color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                hintText: "Write a message",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
