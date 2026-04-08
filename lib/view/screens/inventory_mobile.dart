import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/model/inventory.dart';
import 'package:welcome_project_fe/api_service.dart';


class InventoryMobile extends StatefulWidget {
  const InventoryMobile({super.key});

  @override
  State<InventoryMobile> createState() => _InventoryMobileState();
}

class _InventoryMobileState extends State<InventoryMobile> {
  List<Inventory> items = [];

    @override
    void initState() {
    super.initState();
    loadInventory();
    loadCategories();

}

  Future<void> loadInventory() async {
  try {
    final data = await ApiService.getAllInventoryItems();

    setState(() {
      items = data
          .map((item) => Inventory.fromJson(item))
          .toList();
    });
        print('items length: ${items.length}');

  } catch (e) {
    print(e);
  }
}


Future<void> loadCategories() async {
  try {
    final data = await ApiService.getAllCategories();

    setState(() {
      categories = [
        'All Categories',
        ...data.map((item) => item['category_name'].toString()),
      ];
    });

    print('categories length: ${categories.length}');
  } catch (e) {
    print('loadCategories error: $e');
  }
}


  Future<void> searchInventory(String name) async {
    try {
      if (name.isEmpty) {
        loadInventory();
        return;
      }

      final data = await ApiService.searchInventoryByName(name);

      setState(() {
        items = data
            .map((item) => Inventory.fromJson(item))
            .toList();
      });

      print('search items length: ${items.length}');
    } catch (e) {
      print('searchInventory error: $e');
    }
  }


  Future<void> filterByCategory(String categoryName) async {
  try {
    if (categoryName == 'All Categories') {
      loadInventory();
      return;
    }

    final data = await ApiService.getAllCategories();

    final selected = data.firstWhere(
      (item) => item['category_name'] == categoryName,
    );

    final int categoryId = selected['category_id'];

    final inventoryData =
        await ApiService.getInventoryByCategoryID(categoryId);

    setState(() {
      items = inventoryData
          .map((item) => Inventory.fromJson(item))
          .toList();
    });

    print('filtered items length: ${items.length}');
  } catch (e) {
    print('filterByCategory error: $e');
  }
}


String selectedCategory = 'All Categories';

List<String> categories = ['All Categories'];

  int get totalItems => items.length;

  int get activeItems =>
      items.where((item) => item.status == 'Active').length;

  int get discontinuedItems =>
      items.where((item) => item.status == 'Discontinued').length;

  int get archivedItems =>
      items.where((item) => item.status == 'Archived').length;

  TextEditingController searchController = TextEditingController();

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
                child:  TextField(
                          controller:searchController,
                          onChanged: (value){
                          searchInventory(value);
                          },
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
                    if(value== null)return;

                      setState(() {
                      selectedCategory = value;
                    });
                    filterByCategory(value);
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
                              showDialog(context: context, 
                              builder: (context) => InventoryDetailsPopup(item: item)
                              );
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


class InventoryDetailsPopup extends StatelessWidget {
  final Inventory item;

  const InventoryDetailsPopup({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text("Description: ${item.description}"),
            const SizedBox(height: 8),
            Text("Quantity: ${item.quantity}"),
            const SizedBox(height: 8),
            Text("Status: ${item.status}"),
            const SizedBox(height: 8),
            Text("Created At: ${item.createdAt.toLocal().toString().split('.')[0]}",),            
            const SizedBox(height: 8),
            Text("Updated At: ${item.updatedAt.toLocal().toString().split('.')[0]}",),
            const SizedBox(height: 8),
        
            if (item.deletedAt != null)
            Text("Deleted At: ${item.deletedAt!.toLocal().toString().split('.')[0]}",),
            const SizedBox(height: 8),

            Text("Location: ${item.location}"),
            const SizedBox(height: 8),


            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}