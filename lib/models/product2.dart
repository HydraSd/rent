class Product2 {
  String category;
  List<String> imageUrls;
  List<String> a;
  double weekendPrice;
  double price;
  String description;
  String location;
  String id;
  String userId;
  double long;

  // constructor
  Product2({
    required this.category,
    required this.imageUrls,
    required this.a,
    required this.weekendPrice,
    required this.price,
    required this.description,
    required this.location,
    required this.id,
    required this.userId,
    required this.long,
  });

  // factory method to convert JSON data into Product object
  factory Product2.fromJson(Map<String, dynamic> json) {
    return Product2(
      category: json['catagory'],
      imageUrls: List<String>.from(json['imgUrl']),
      a: List<String>.from(json['a']),
      weekendPrice: double.parse(json['weekendPrice']),
      price: double.parse(json['price']),
      description: json['description'],
      location: json['location'],
      id: json['id'],
      userId: json['userId'],
      long: double.parse(json['long']),
    );
  }

  // method to convert Product object into JSON data
  Map<String, dynamic> toJson() => {
        'catagory': category,
        'imgUrl': imageUrls,
        'a': a,
        'weekendPrice': weekendPrice.toString(),
        'price': price.toString(),
        'description': description,
        'location': location,
        'id': id,
        'userId': userId,
        'long': long.toString(),
      };
}
