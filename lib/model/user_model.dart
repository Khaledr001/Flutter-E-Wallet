class UserModel {
  String name;
  String email;
  String bio;
  // String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  double balance;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    // required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.balance,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      balance: map['balance'] ?? '',
      // profilePic: map['profilePic'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "balance": balance,
      "name": name,
      "email": email,
      "uid": uid,
      "bio": bio,
      // "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
    };
  }
}
