class Register {
  String userId;
  String businessName;
  String logoUrl;
  String phoneNumber;
  String description;

  Register(
      {required this.userId,
      required this.businessName,
      required this.logoUrl,
      required this.phoneNumber,
      required this.description});

  Map<String, dynamic> toJson() => {
        'logoUrl': logoUrl,
        'userId': userId,
        'businessName': businessName,
        'phoneNumber': phoneNumber,
        'description': description,
      };
}
