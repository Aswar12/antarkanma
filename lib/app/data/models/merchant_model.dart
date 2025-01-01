class MerchantModel {
  final int? id;
  final int ownerId;
  final String name;
  final String address;
  final String phoneNumber;
  final String? status;
  final String? description;
  final String? logo;
  final String? openingTime;
  final String? closingTime;
  final List<String>? operatingDays;
  final DateTime createdAt; 
  final int? orderCount;
  final int? productsSold;
  final int? totalSales;
  final int? monthlyRevenue;
  final int? productCount;
  final DateTime updatedAt;

  MerchantModel({
    this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    this.status = 'ACTIVE',
    this.description,
    this.logo,
    required this.createdAt,
    this.productCount,
    required this.updatedAt,
    this.openingTime,
    this.closingTime,
    this.operatingDays,
    this.orderCount,
    this.productsSold,
    this.totalSales,
    this.monthlyRevenue,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    try {
      int? parseInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value == 0 ? null : value;  // Return null for ID 0
        if (value is String) {
          try {
            final parsed = int.parse(value);
            return parsed == 0 ? null : parsed;  // Return null for ID 0
          } catch (e) {
            print('Error parsing $value to int: $e');
            return null;
          }
        }
        return null;
      }

      List<String>? parseOperatingDays(dynamic value) {
        if (value == null) return null;
        if (value is List) {
          return value.map((e) => e.toString()).toList();
        }
        if (value is String && value.isNotEmpty) {
          return value.split(',').map((e) => e.trim()).toList();
        }
        return [];
      }

      return MerchantModel(
        id: parseInt(json['id']),  // This will now return null for ID 0
        ownerId: parseInt(json['owner_id'].toString()) ?? 0,
        name: json['name']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        phoneNumber: json['phone_number']?.toString() ?? '',
        status: json['status']?.toString() ?? 'ACTIVE',
        description: json['description']?.toString(),
        logo: json['logo']?.toString(),
        openingTime: json['opening_time']?.toString(),
        closingTime: json['closing_time']?.toString(),
        operatingDays: parseOperatingDays(json['operating_days']),
        productCount: parseInt(json['product_count']),
        orderCount: parseInt(json['order_count']),
        productsSold: parseInt(json['products_sold']),
        totalSales: parseInt(json['total_sales']),
        monthlyRevenue: parseInt(json['monthly_revenue']),
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (e) {
      // Return a minimal valid merchant with null ID instead of 0
      return MerchantModel(
        id: null,  // Changed from 0 to null
        ownerId: 0,
        name: '',
        address: '',
        phoneNumber: '',
        description: null,
        logo: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productCount: 0,
        orderCount: 0,
        productsSold: 0,
        totalSales: 0,
        monthlyRevenue: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'status': status,
      'description': description,
      'logo': logo,
      'product_count': productCount,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'operating_days': operatingDays,
      'order_count': orderCount,
      'products_sold': productsSold,
      'total_sales': totalSales,
      'monthly_revenue': monthlyRevenue,
    };
  }

  MerchantModel copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? address,
    String? phoneNumber,
    String? status,
    String? description,
    String? logo,
    int? productCount,
    String? openingTime,
    String? closingTime,
    List<String>? operatingDays,
    int? orderCount,
    int? productsSold,
    int? totalSales,
    int? monthlyRevenue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MerchantModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      productCount: productCount ?? this.productCount,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      operatingDays: operatingDays ?? this.operatingDays,
      orderCount: orderCount ?? this.orderCount,
      productsSold: productsSold ?? this.productsSold,
      totalSales: totalSales ?? this.totalSales,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status?.toUpperCase() == 'ACTIVE';

  MerchantModel updateStatus(String newStatus) {
    return copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
  }

  String get formattedPhoneNumber => phoneNumber;

  String get summary => '$name - $address';

  String? get merchantLogoUrl => logo;
  String get merchantName => name;
  String get merchantContact => phoneNumber;
  String? get merchantOpeningHours => openingTime;
  List<String>? get merchantOperatingDays => operatingDays;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MerchantModel &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.status == status &&
        other.description == description &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        status.hashCode ^
        description.hashCode ^
        logo.hashCode;
  }

  @override
  String toString() {
    return 'MerchantModel(id: $id, name: $name, status: $status, description: $description, logo: $logo)';
  }
}
