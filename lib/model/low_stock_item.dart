class LowStockItem {
  final int inventoryId;
  final String inventoryName;
  final int inventoryQuantity;
  final String inventoryLocation;
  final String supplierName;
  final String categoryName;

  LowStockItem({
    required this.inventoryId,
    required this.inventoryName,
    required this.inventoryQuantity,
    required this.inventoryLocation,
    required this.supplierName,
    required this.categoryName,
  });

  factory LowStockItem.fromJson(Map<String, dynamic> json) {
    return LowStockItem(
      inventoryId: json['inventory_id'] ?? 0,
      inventoryName: json['inventory_name'] ?? '',
      inventoryQuantity: json['inventory_quantity'] ?? 0,
      inventoryLocation: json['inventory_location'] ?? 'N/A',
      supplierName: json['supplier_name'] ?? 'Unknown Supplier',
      categoryName: json['category_name'] ?? 'Unknown Category',
    );
  }
}