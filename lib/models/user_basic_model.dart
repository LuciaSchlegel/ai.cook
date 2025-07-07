class UserBasicModel {
  final String uid;

  UserBasicModel({required this.uid});

  factory UserBasicModel.fromJson(Map<String, dynamic> json) {
    return UserBasicModel(uid: json['uid']);
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid};
  }
}
