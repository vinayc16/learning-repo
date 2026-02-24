class EcartProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String? category;
  final int stock;
  final double? rating;
  final bool isFeatured;
  final DateTime createdAt;

  EcartProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.category,
    this.rating,
    this.stock = 0,
    this.isFeatured = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert JSON to Model
  factory EcartProductModel.fromJson(Map<String, dynamic> json) {
    return EcartProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      rating: json['rating']?.toDouble(),
      stock: json['stock'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'stock': stock,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
