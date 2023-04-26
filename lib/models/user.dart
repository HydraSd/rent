class UserData {
  String userId;
  String contactNumber;
  String IdNumber;

  UserData({
    required this.userId,
    required this.contactNumber,
    required this.IdNumber,
  });

  Map<String, dynamic> toJson() =>
      {'userId': userId, 'contactNumber': contactNumber, 'IdNumber': IdNumber};
}
