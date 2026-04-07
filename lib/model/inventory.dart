class Inventory {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String status;
  final String location;

  Inventory({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.status,
    required this.location,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['inventory_id'],
      name: json['inventory_name'],
      description: json['inventory_description'] ?? '',
      quantity: json['inventory_quantity'],
      status: json['inventory_status'],
      location: json['inventory_location'] ?? '',
    );
  }

}