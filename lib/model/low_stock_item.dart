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
      id: json['inventory_id'] ?? 0,
      name: json['inventory_name'] ?? '',
      quantity: json['inventory_quantity'] ?? 0,
      location: json['inventory_location'] ?? 'N/A',
      supplierName: json['supplier_name'] ?? 'Unknown',
      categoryName: json['category_name'] ?? 'Unknown',
    );
  }
}