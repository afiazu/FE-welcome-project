class Supplier {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String createdAt;
  
  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['supplier_id'] ?? 0,
      name: json['supplier_name'] ?? json['supplier_name'] ?? 'No Name',
      phone: json['supplier_num']?.toString() ?? '',
      email: json['supplier_email'] ?? '',
      address: json['supplier_address'] ?? '',
      createdAt: json['created_at'] ?? json['created_at'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Supplier(id: $id, name: $name, phone: $phone, email: $email)';
  }
}