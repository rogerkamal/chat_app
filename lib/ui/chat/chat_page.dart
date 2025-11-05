import 'package:chat_app/data/model/message_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String fromId = '';
  var msgController = TextEditingController();
  DateFormat dateFormat = DateFormat.Hm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeChatRoom();
  }

  void initializeChatRoom() async {


    fromId = await FirebaseRepository.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("FromId ===$fromId");
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
                                    ? NetworkImage(widget.uProfilePic)
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
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseRepository.getChatStream(
                  fromId: fromId,
                  toId: widget.userId,
                ),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  listMsg = List.generate(
                    snapshot.data!.docs.length,
                    (index) =>
                        MessageModel.fromDoc(snapshot.data!.docs[index].data()),
                  );


                if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){

                  return ListView.builder(
                    itemCount: listMsg.length,
                    itemBuilder: (_, index) {
                      return listMsg[index].fromId == fromId
                          ? userChatBox(listMsg[index])
                          : anotherUserChatBox(listMsg[index],index);
                    },
                  );

                }else{
                  return Center(child:
                    Text("No messages yet! \nStart a conversation today..",style: TextStyle(color: Colors.grey),),);
                }


                },
              ),
            ),

            SizedBox(height: 7),
            TextField(
              style: TextStyle(color: Colors.grey),
              cursorColor: Colors.white,
              controller: msgController,
              enableSuggestions: true,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    FirebaseRepository.sendTextMessage(
                      toId: widget.userId,
                      msg: msgController.text,
                    );
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
        ///right side
  Widget userChatBox(MessageModel msgModel) {
    var time = dateFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );
    return Row(
      children: [
        Container(width: MediaQuery.of(context).size.width * 0.2),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(
                color: Colors.white.withAlpha(200),
                width: 2,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(child: Text(msgModel.msg!, style: TextStyle(color: Colors.white))),
                Text(time, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }


      ///left side
  Widget anotherUserChatBox(MessageModel msgModel, int index) {
    var time = dateFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)),
    );
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.amber.shade900.withOpacity(0.5),
                width: 2,
              ),
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        backgroundImage:
                        widget.uProfilePic != ""
                            ? NetworkImage(widget.uProfilePic)
                            : AssetImage(
                          'assets/app_image/ic_user.png',
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Text(msgModel.msg!,style: TextStyle(color: Colors.black),),
                  ),
                ),
                SizedBox(child:Text(time, style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
        Container(width: MediaQuery.of(context).size.width * 0.2),
      ],
    );
  }
}
