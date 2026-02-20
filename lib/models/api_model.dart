class ApiProduct{
  final int id;
  final String title;
  final double price;
  final String category;

  ApiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
    );
  }
}
