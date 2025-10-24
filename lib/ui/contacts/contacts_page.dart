import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

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
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index){
                    var currModel = UserModel.fromDoc(snapshot.data!.docs[index].data());
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(child: 
                      ListTile(
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
