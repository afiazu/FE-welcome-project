import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/model/inventory.dart';

class InventoryDesktop extends StatefulWidget {
  const InventoryDesktop({super.key});

  @override
  State<InventoryDesktop> createState() => _InventoryDesktopState();
}

class _InventoryDesktopState extends State<InventoryDesktop> {
  //fake data
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
    Inventory(
      id: 105,
      name: 'LED Desk Lamp',
      description: 'Energy-saving desk lamp',
      quantity: 78,
      status: 'Archived',
      location: 'Warehouse B',
    ),
    Inventory(
      id: 106,
      name: 'USB-C Hub',
      description: 'Multi-port adapter hub',
      quantity: 156,
      status: 'Active',
      location: 'Warehouse A',
    ),
    Inventory(
      id: 107,
      name: 'Mechanical Keyboard',
      description: 'RGB mechanical keyboard',
      quantity: 0,
      status: 'Discontinued',
      location: 'Warehouse C',
    ),
    Inventory(
      id: 108,
      name: 'Standing Desk',
      description: 'Height adjustable desk',
      quantity: 24,
      status: 'Active',
      location: 'Warehouse B',
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory Management',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ubtsBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage and track your inventory items',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
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
                          ),
                          const SizedBox(width: 12),
                          
                          Container(
                            height: 50,
                            width: 160,
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
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _buildCard('Total', totalItems.toString()),
                          const SizedBox(width: 12),
                          _buildCard('Active', activeItems.toString()),
                          const SizedBox(width: 12),
                          _buildCard('Archive', archivedItems.toString()),
                          const SizedBox(width: 12),
                          _buildCard(
                            'Discontinued',
                            discontinuedItems.toString(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Inventory List",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              //column name placed
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                color: ColorConstants.ubtsBlue,
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          "Qty",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Location",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Action",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final item = items[index];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),


                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(item.name),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                item.quantity.toString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(item.status),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(item.location),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    print("View ${item.name}"); //view button
                                                  },
                                                  child: const Text("View"),
                                                ),
                                              ],
                                            ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}