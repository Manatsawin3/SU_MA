class Product {
  final dynamic id;
  final String name;
  final String description;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
  );

  Map<String, dynamic> toJson() {
    final map = {'name': name, 'description': description, 'price': price};
    if (id != null) map['id'] = id;
    return map;
  }
}
