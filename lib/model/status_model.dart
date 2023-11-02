class Status {
  // final String uid;
  // final String username;
  // final String phoneNumber;
  // final List<String> photoUrl;
  // final DateTime createdAt;
  final String profilePic;
  // final List<String> whoCanSee;
  Status({
    // required this.uid,
    // required this.username,
    // required this.phoneNumber,
    // required this.photoUrl,
    // required this.createdAt,
    required this.profilePic, 
    // required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid,
      // 'username': username,
      // 'phoneNumber': phoneNumber,
      // 'photoUrl': photoUrl,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      'photo': profilePic,
      // 'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      // uid: map['uid'] ?? '',
      // username: map['username'] ?? '',
      // phoneNumber: map['phoneNumber'] ?? '',
      // photoUrl: List<String>.from(map['photoUrl']),
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['photo'] ?? '',
      // whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
