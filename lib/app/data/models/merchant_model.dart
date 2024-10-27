class MerchantModel {
  final int? id; // ID merchant
  final int ownerId; // ID pemilik (FK ke Users)
  final String name; // Nama merchant
  final String address; // Alamat merchant
  final String phoneNumber; // Nomor telepon merchant
  final DateTime createdAt; // Waktu pembuatan
  final DateTime updatedAt; // Waktu pembaruan

  MerchantModel({
    this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor untuk data dari API
  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as int?,
      ownerId: json['owner_id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MerchantModel &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.address == address &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode;
  }
}
