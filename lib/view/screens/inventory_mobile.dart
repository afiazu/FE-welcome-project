import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/model/inventory.dart';

class InventoryMobile extends StatefulWidget {
  const InventoryMobile({super.key});

  @override
  State<InventoryMobile> createState() => _InventoryMobileState();
}

class _InventoryMobileState extends State<InventoryMobile> {
  List<Inventory> items = [
    Inventory(
      id: 101,
      name: 'Laptop - Dell XPS 15',
      description: 'High-performance business laptop',
      quantity: 45,
      status: 'Active',
      location: 'Warehouse A',
    ),
    Inventory(
      id: 102,
      name: 'Ergonomic Office Chair',
      description: 'Adjustable chair with lumbar support',
      quantity: 120,
      status: 'Active',
      location: 'Warehouse B',
    ),
    Inventory(
      id: 103,
      name: 'Wireless Mouse - Logitech',
      description: '2.4GHz wireless optical mouse',
      quantity: 0,
      status: 'Discontinued',
      location: 'Warehouse A',
    ),
    Inventory(
      id: 104,
      name: '27-inch 4K Monitor',
      description: 'Ultra HD display monitor',
      quantity: 32,
      status: 'Active',
      location: 'Warehouse C',
    ),
  ];

  String selectedCategory = 'All Categories';

  final List<String> categories = [
    'All Categories',
    'Electronics',
    'Furniture',
  ];

  int get totalItems => items.length;

  int get activeItems =>
      items.where((item) => item.status == 'Active').length;

  int get discontinuedItems =>
      items.where((item) => item.status == 'Discontinued').length;

  int get archivedItems =>
      items.where((item) => item.status == 'Archived').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ubtsBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage and track your inventory items',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),

              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: categories.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

            //board 
              Row(
                children: [
                  _buildSmallCard('Total', totalItems.toString()),
                  const SizedBox(width: 10),
                  _buildSmallCard('Active', activeItems.toString()),
                ],
              ),
              const SizedBox(height: 10),
              Row(

                children: [
                  _buildSmallCard('Archive', archivedItems.toString()),
                  const SizedBox(width: 10),
                  _buildSmallCard(
                    'Discontinued',
                    discontinuedItems.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Inventory List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Qty: ${item.quantity}'),
                          const SizedBox(height: 4),
                          Text('Status: ${item.status}'),
                          const SizedBox(height: 4),
                          Text('Location: ${item.location}'),
                          const SizedBox(height: 12),

                          //view button
                          ElevatedButton(
                            onPressed: () {
                              print("View ${item.name}");
                            },
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}