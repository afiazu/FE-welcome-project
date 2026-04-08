class LowStockItem {
  final int id;
  final String name;
  final int quantity;
  final String location;
  final String supplierName;
  final String categoryName;

  LowStockItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.location,
    required this.supplierName,
    required this.categoryName,
  });

  factory LowStockItem.fromJson(Map<String, dynamic> json) {
    return LowStockItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      location: json['location'] ?? 'N/A',
      supplierName: json['supplierName'] ?? 'Unknown Supplier',
      categoryName: json['categoryName'] ?? 'Unknown Category',
    );
  }
}