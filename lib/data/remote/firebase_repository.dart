import 'package:chat_app/data/model/message_model.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/domain/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRepository {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_CHATROOM = "chatroom";
  static const String COLLECTION_MESSAGES = "messages";

  Future<void> createUser({
    required UserModel user,
    required String pass,
  }) async {
    try {
      var userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: pass,
      );

      if (userCred.user!= null) {
        user.userId = userCred.user!.uid;
        firestore
            .collection(COLLECTION_USERS)
            .doc(userCred.user!.uid)
            .set(user.toDoc())
            .catchError((error){
              throw(Exception("Error: $error"));
        });
      }
    } on FirebaseAuthException catch (e) {

      throw(Exception("Error: $e"));
    } catch (e) {
      throw(Exception("Error: $e"));

    }
  }

  Future<void> loginUser({
    required String email,
    required String pass,
  }) async {
    try {
      var userCred = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass);

      if (userCred.user!= null) {
        ///add userid in Sharedprefs
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppConstants.prefUserIdKey, userCred.user!.uid);
      }
    } on FirebaseAuthException catch (e) {

      throw(Exception("Error: Invalid email or Password"));
    } catch (e) {
      throw(Exception("Error: $e"));

    }
  }


  static Future<QuerySnapshot<Map<String,dynamic>>> getAllContacts(){
    return firestore.collection(COLLECTION_USERS).get();
    }

  static Future<String> getFromId() async {
      var prefs = await  SharedPreferences.getInstance();
      return prefs.getString(AppConstants.prefUserIdKey)!;
  }

  static String getChatId({required  String fromId, required String toId}){
  if(fromId.hashCode<=toId.hashCode){
    return "${fromId}_${toId}";
  }else{
    return "${toId}_${fromId}";
  }
}

  static sendTextMessage({required String toId, required String msg}) async {
    String fromId = await getFromId();

    var chatId = await getChatId(fromId: fromId, toId: toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
        msgId: currTime,
        msg: msg,
        sentAt: currTime,
        fromId: fromId,
        toId: toId);

    firestore.collection(COLLECTION_CHATROOM)
    .doc(chatId)
    .collection(COLLECTION_MESSAGES)
    .doc(currTime)
    .set(msgModel.toDoc());
  }


  static sendImageMessage({required String toId, required String imgUrl, String msg = ""}) async {
    String fromId = await getFromId();

    var chatId = await getChatId(fromId: fromId, toId: toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
        msgId: currTime,
        msg: msg,
        sentAt: currTime,
        fromId: fromId,
        toId: toId,
        imgUrl: imgUrl,
        msgType: 1);

    firestore.collection(COLLECTION_CHATROOM)
    .doc(chatId)
    .collection(COLLECTION_MESSAGES)
    .doc(currTime)
    .set(msgModel.toDoc());
  }


}
