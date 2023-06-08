class Saved {
  List productId;
  String userId;

  Saved({required this.productId, required this.userId});

  Map<String, dynamic> toJson() => {'productId': productId};
}
