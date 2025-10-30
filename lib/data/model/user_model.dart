class UserModel{
  String? userId;
  String? name;
  String? email;
  String? mobNo;
  String? gender;
  String? createdAt;
  bool isOnline = false;
  int? status = 1;   //1->Active, 2->InActive, 3->Suspended
  String? profilePic ="";
  int? profileStatus = 1; //1-> public, 2-> friends, 3-> private


  UserModel({
    this.userId,
    required this.name,
    required this.createdAt,
    required this.email,
    required this.gender,
    required this.isOnline,
    required this.mobNo,
    required this.profilePic,
    required this.profileStatus,
    required this.status,
});

  Map<String, dynamic> toDoc()  =>{
    'name': name,
    'userId' : userId,
    'createdAt' : createdAt,
    'email' : email,
    'gender' : gender,
    'isOnline' : isOnline,
    'mobNo' : mobNo,
    'profilePic' : profilePic,
    'profileStatus' : profileStatus,
    'status' : status
  };

  factory UserModel.fromDoc(Map<String, dynamic> document){
    return UserModel(
        userId: document['userId'],
        name: document['name'],
        createdAt: document['createdAt'],
        email: document['email'],
        gender: document['gender'],
        isOnline: document['isOnline'],
        mobNo: document['mobNo'],
        profilePic: document['profilePic'],
        profileStatus: document['profileStatus'],
        status: document['status']
    );
  }


}