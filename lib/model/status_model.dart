class Status {
  final String profilePic;
  final String? id;
  final String? statusId;
  final String? name;
  final String? dateTime;
  final String? caption;
  Status(
      {required this.name,
      required this.dateTime,
      required this.profilePic,
      this.id,
      required this.statusId,
      this.caption});

  Map<String, dynamic> toMap() {
    return {
      'photo': profilePic,
      'statusId': statusId,
      "id": id,
      "name": name,
      "time": dateTime,
      "caption": caption,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      profilePic: map['photo'] ?? '',
      statusId: map['statusId'] ?? '',
      dateTime: map['time'],
      id: map['id'],
      name: map['name'],
      caption: map['caption'],
    );
  }
}
