import 'package:flutter/foundation.dart';

class ProductModel {
  final int? id; // Ditambahkan untuk API
  final String name;
  final String description;
  final List<String> imageUrls;
  final double price;
  final String? tags; // Opsional dari API
  final KedaiModel? kedai; // Opsional dari API
  final CategoryModel? category; // Opsional dari API
  final DateTime? createdAt; // Opsional dari API
  final DateTime? updatedAt; // Opsional dari API

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.price,
    this.tags,
    this.kedai,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor untuk data dari API
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      imageUrls: json['galleries'] != null
          ? (json['galleries'] as List)
              .map<String>((gallery) => gallery['url'] as String)
              .toList()
          : [],
      tags: json['tags'] as String?,
      kedai: json['kedai'] != null ? KedaiModel.fromJson(json['kedai']) : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Constructor untuk data lokal (sesuai model lama)
  factory ProductModel.local({
    required String name,
    required String description,
    required List<String> imageUrls,
    required double price,
  }) {
    return ProductModel(
      name: name,
      description: description,
      imageUrls: imageUrls,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'tags': tags,
      'kedai': kedai?.toJson(),
      'category': category?.toJson(),
      'galleries': imageUrls.map((url) => {'url': url}).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Untuk membuat salinan objek dengan beberapa perubahan
  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? imageUrls,
    double? price,
    String? tags,
    MerchantModel? kedai,
    CategoryModel? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      kedai: kedai ?? this.kedai,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrls.hashCode ^
        price.hashCode;
  }
}

// Untuk data kosong/tidak diinisialisasi
class UninitializedProductModel extends ProductModel {
  UninitializedProductModel()
      : super(
          id: 0,
          name: '',
          description: '',
          imageUrls: [],
          price: 0.0,
        );
}
