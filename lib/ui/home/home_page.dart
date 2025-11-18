import 'package:chat_app/data/model/message_model.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:chat_app/domain/utils/app_constants.dart';
import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:chat_app/ui/chat/chat_page.dart';
import 'package:chat_app/ui/contacts/contacts_page.dart';
import 'package:chat_app/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fromId = '';

  @override
  void initState() {
    super.initState();
    initializeChatRoom();
  }

  void initializeChatRoom() async {
    fromId = await FirebaseRepository.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) async {
              if (value == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }

              if (value == 2) {
                /// Logout logic
                SharedPreferences? prefs =
                    await SharedPreferences.getInstance();
                prefs.remove(AppConstants.prefUserIdKey);
                Navigator.pushReplacementNamed(context, AppRoutes.signin);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Logged out !")));
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<int>(
                    value: 1,
                    enabled: false, // disable default tap
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*isDarkTheme
                        ? Text(
                      "Dark Theme",
                      style: TextStyle(color: Colors.white),
                    )
                        : Text(
                      "Dark Theme",
                      style: TextStyle(color: Colors.black),
                    ),
                    Switch(
                      value: isDarkTheme,
                      onChanged: (val) {
                        context.read<ThemeProvider>().isDarkTheme = val;
                        Navigator.pop(context); // close popup
                      },
                    ),*/
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Text("Logout"),
                        SizedBox(width: 10),
                        Icon(Icons.logout, weight: 20),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: [
                        Text("Settings"),
                        SizedBox(width: 10),
                        Icon(Icons.settings),
                      ],
                    ),
                  ),
                ],
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Messages", style: TextStyle(color: Colors.grey))],
        ),
      ),
      body: Container(
        color: Colors.grey.shade800,
        child: StreamBuilder(
          stream: FirebaseRepository.getLiveChatContactStream(fromId: fromId),
          builder: (_, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            }

            if (snapshots.hasError) {
              return Center(child: Text(snapshots.error.toString()));
            }

            if (snapshots.hasData) {
              var listUserId = List.generate(snapshots.data!.docs.length, (
                index,
              ) {
                var mData =
                    snapshots.data!.docs[index].get('ids') as List<dynamic>;
                mData.removeWhere((element) => element == fromId);
                return mData[0];
              });

              print('==ToUsers chats ==== $listUserId');
              return ListView.builder(
                itemCount: listUserId.length,
                itemBuilder: (_, index) {
                  return FutureBuilder(
                    future: FirebaseRepository.getUserByUserId(
                      userId: listUserId[index],
                    ),
                    builder: (_, userSnap) {
                      if (userSnap.hasData) {
                        var currModel = UserModel.fromDoc(
                          userSnap.data!.data()!,
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.black,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChatPage(
                                          userId: currModel.userId!,
                                          uName: currModel.name!,
                                          uProfilePic: currModel.profilePic!,
                                        ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    currModel.profilePic != ""
                                        ? NetworkImage(currModel.profilePic!)
                                        : AssetImage(
                                          'assets/app_image/ic_user.png',
                                        ),
                              ),
                              title: Text(currModel.name!,style: TextStyle(color: Colors.white),),
                              subtitle: StreamBuilder(
                                stream: FirebaseRepository.getLastMsg(
                                  fromId: fromId,
                                  toId: currModel.userId!,
                                ),
                                builder: (_, lastMsgSnapshots) {
                                  if (lastMsgSnapshots.hasData) {
                                    var lastMsg = MessageModel.fromDoc(
                                      lastMsgSnapshots.data!.docs[0].data(),
                                    );

                                    return lastMsg.fromId == fromId
                                        ? Row(
                                          children: [
                                            Icon(
                                              Icons.done_all,
                                              color:
                                                  lastMsg.readAt != ""
                                                      ? Colors.blue
                                                      : Colors.grey,
                                              size: 16,
                                            ),
                                            Text(
                                              lastMsg.msg!,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                        : Text(
                                          lastMsg.msg!,
                                          style: TextStyle(color: Colors.grey),
                                        );
                                  }
                                  return Text(currModel.email!.toString());
                                },
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseRepository.getLastMsg(
                                      fromId: fromId,
                                      toId: currModel.userId!,
                                    ),
                                    builder: (_, lastMsgTimeSnapshot) {
                                      if (lastMsgTimeSnapshot.hasData) {
                                        var lastTime = MessageModel.fromDoc(
                                          lastMsgTimeSnapshot.data!.docs[0]
                                              .data(),
                                        );

                                        var time = ChatPage.dateFormat.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(lastTime.sentAt!),
                                          ),
                                        );

                                        return Text(
                                          time,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                      return SizedBox(height: 0, width: 0);
                                    },
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseRepository.getUnReadCount(
                                      fromId: fromId,
                                      toId: currModel.userId!,
                                    ),
                                    builder: (_, unReadMsgCountSnap) {
                                      if (unReadMsgCountSnap.hasData &&
                                          unReadMsgCountSnap
                                              .data!
                                              .docs
                                              .isNotEmpty) {
                                        return CircleAvatar(
                                          radius: 10,
                                          child: Text(
                                            '${unReadMsgCountSnap.data!.docs.length}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }
                                      return SizedBox(height: 0, width: 0);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
        },
        child: Icon(Icons.message, color: Colors.orange),
      ),
    );
  }
}
