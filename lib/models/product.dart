class Product {
  String id;
  final String productName;
  final String catagory;
  final List imgUrl;
  final String description;
  final double price;

  final String userID;
  final double lat;
  final double long;
  final String location;
  final String phoneNumber;
  final int requests;

  Product(
      {this.id = '',
      required this.price,
      required this.imgUrl,
      required this.productName,
      required this.description,
      required this.catagory,
      required this.userID,
      required this.lat,
      required this.long,
      required this.location,
      required this.phoneNumber,
      this.requests = 0});

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'id': id,
        'productName': productName,
        'category': catagory,
        'description': description,
        'price': price,
        'userId': userID,
        'location': location,
        'lat': lat,
        'long': long,
        'phoneNumber': phoneNumber,
        'requests': requests
      };
}
