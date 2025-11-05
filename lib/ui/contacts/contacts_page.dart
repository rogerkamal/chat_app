import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:chat_app/ui/chat/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String currUserEmailId='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser() async {
    currUserEmailId =  await FirebaseRepository.getFromId();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Contacts'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
          future: FirebaseRepository.getAllContacts(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            }else if(snapshot.hasData){

              var listContact = List
              .generate(snapshot.data!.docs.length, (index){
                return UserModel.fromDoc(snapshot.data!.docs[index].data());
              });


             /* // Convert snapshot to UserModel list
              final docs = snapshot.data!.docs;

              //  Filter out current user you don’t want to show
              final filteredDocs = docs.where((doc) {
                var user = UserModel.fromDoc(doc.data());
                return user.email != getCurrentUser();  // show only active users
              }).toList();*/
              listContact.removeWhere((element) => element.userId == currUserEmailId);

              return ListView.builder(
                  itemCount: listContact.length,
                  itemBuilder: (_, index){
                    var currModel = listContact[index];


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(child:
                      ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userId: currModel.userId!, uName: currModel.name!, uProfilePic: currModel.profilePic!,)));
                        },
                        leading: CircleAvatar(
                          backgroundImage: currModel.profilePic != "" ? NetworkImage(currModel.profilePic!) : AssetImage('assets/app_image/ic_user.png')
                        ),
                        title: Text(currModel.name!),
                        subtitle: Text(currModel.email!.toString()),
                      )),
                    );
                  });
            }
            return Container();
          }),
    );
  }

}
