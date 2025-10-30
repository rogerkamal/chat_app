class MessageModel {
  String? msgId;
  String? msg;
  String? sentAt;
  String? readAt;
  String? fromId;
  String? toId;
  int? msgType; //0 -> text, 1 -> image
  String? imgUrl;

  MessageModel({
    required this.msgId,
    required this.msg,
    required this.sentAt,
    this.readAt = "",
    required this.fromId,
    required this.toId,
    this.msgType = 0,
    this.imgUrl = ""});

  factory MessageModel.fromDoc(Map<String,dynamic> document){
    return MessageModel(
        msgId: document['msgId'],
        msg: document['msg'],
        sentAt: document['sentAt'],
        readAt: document['readAt'],
        fromId: document['fromId'],
        toId: document['toId'],
        msgType: document['msgType'],
        imgUrl: document['imgUrl']
    );
  }

  Map<String, dynamic> toDoc() => {
    'msg' :msg,
    'msgId' :msgId,
    'sentAt' :sentAt,
    'readAt' :readAt,
    'fromId': readAt,
    'toId' : toId,
    'msgType' :msgType,
    'imgUrl' :imgUrl
  };

}
