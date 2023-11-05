class Status {
  final String profilePic;

  final String? statusId;
  // final List<String> whoCanSee;
  Status({
    required this.profilePic,
    this.statusId,
  });

  Map<String, dynamic> toMap() {
    return {
      'photo': profilePic,
      'id': statusId,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      profilePic: map['photo'] ?? '',
      statusId: map['id'] ?? '',
    );
  }
}
