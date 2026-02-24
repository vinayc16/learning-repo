import 'category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;
  final String? creationAt;
  final String? updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    this.creationAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      images: List<String>.from(json['images'] ?? []),
      creationAt: json['creationAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toJson(),
      'images': images,
      if (creationAt != null) 'creationAt': creationAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  /// For creating a new product (POST request)
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': category.id,
      'images': images,
    };
  }

  /// For updating a product (PUT/PATCH request)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price)';
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? slug,
    double? price,
    String? description,
    CategoryModel? category,
    List<String>? images,
    String? creationAt,
    String? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      images: images ?? this.images,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
