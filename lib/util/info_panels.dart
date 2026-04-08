import 'package:flutter/material.dart';
import '../model/low_stock_item.dart';
import '../model/category.dart';  

class LowStockPanel extends StatelessWidget {
  final List<LowStockItem> lowStockItems;
  const LowStockPanel({super.key, required this.lowStockItems});

  @override
  Widget build(BuildContext context) {
    if (lowStockItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        color: Colors.green,
        title: 'No Low Stock Items',
        subtitle: 'All inventory levels are good!',
      );
    }

    return _buildPanel(
      icon: Icons.warning,
      color: Colors.orange,
      title: 'Low Stock Items',
      items: lowStockItems,
    );
  }
}

class DiscontinuedPanel extends StatelessWidget {
  final List<LowStockItem> discontinuedItems;
  const DiscontinuedPanel({super.key, required this.discontinuedItems});

  @override
  Widget build(BuildContext context) {
    if (discontinuedItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        color: Colors.green,
        title: 'No Discontinued Items',
        subtitle: 'All items are active!',
      );
    }

    return _buildPanel(
      icon: Icons.cancel,
      color: Colors.red,
      title: 'Discontinued Items',
      items: discontinuedItems,
    );
  }
}

// Add this new CategoriesPanel
class CategoriesPanel extends StatelessWidget {
  final List<Category> categories;
  const CategoriesPanel({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState(
        icon: Icons.category,
        color: Colors.purple,
        title: 'No Categories',
        subtitle: 'No categories found in the system!',
      );
    }

    return _buildCategoryPanel(
      icon: Icons.category,
      color: Colors.purple,
      title: 'Categories',
      categories: categories,
    );
  }
}

Widget _buildCategoryPanel({
  required IconData icon,
  required Color color,
  required String title,
  required List<Category> categories,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                '$title (${categories.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created: ${category.createdAt.substring(0, 10)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPanel({
  required IconData icon,
  required Color color,
  required String title,
  required List<LowStockItem> items,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                '$title (${items.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supplier: ${item.supplierName}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Category: ${item.categoryName}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Location: ${item.location}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Quantity left: ${item.quantity}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}