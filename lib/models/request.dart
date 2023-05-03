class Request {
  String userId;
  String userName;
  String contactNumber;
  String idNumber;
  String productName;

  Request({
    required this.userId,
    required this.contactNumber,
    required this.idNumber,
    required this.userName,
    required this.productName,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'contactNumber': contactNumber,
        'IdNumber': idNumber,
        'RequestedUser': userName,
        'ProductName': productName,
      };
}
