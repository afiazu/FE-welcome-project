import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/model/inventory.dart';
import 'package:welcome_project_fe/model/low_stock_item.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/DesktopSideBar.dart';

class InventoryDesktop extends StatefulWidget {
  const InventoryDesktop({super.key});

  @override
  State<InventoryDesktop> createState() => _InventoryDesktopState();
}

class _InventoryDesktopState extends State<InventoryDesktop> {

Widget _buildHeaderCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: isCenter
          ? Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildBodyCell(String text, {bool isCenter = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: isCenter ? Center(child: Text(text)) : Text(text),
    );
  }
  
  List<Inventory> items = [];
  String selectedCategory = 'All Categories';
  List<String> categories = ['All Categories'];
  TextEditingController searchController = TextEditingController();

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
        items = data.map((item) => Inventory.fromJson(item)).toList();
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
        items = data.map((item) => Inventory.fromJson(item)).toList();
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
        items = inventoryData.map((item) => Inventory.fromJson(item)).toList();
      });

      print('filtered items length: ${items.length}');
    } catch (e) {
      print('filterByCategory error: $e');
    }
  }

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
      appBar: AppBar(
        backgroundColor: ColorConstants.ubtsBlue,
        elevation: 0,
        title: const Text(
          'Inventory Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: 70),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    flex: 3,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          searchInventory(value);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Search inventory...',
                                          prefixIcon: Icon(Icons.search),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
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
                                        if (value == null) return;

                                        setState(() {
                                          selectedCategory = value;
                                        });
                                        filterByCategory(value);
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


                                      Expanded(
                                            child: SingleChildScrollView(
                                              child: Table(
                                                border: TableBorder(
                                                  horizontalInside: BorderSide(color: Colors.grey.shade300),
                                                  verticalInside: BorderSide(color: Colors.grey.shade300),
                                                  top: BorderSide(color: Colors.grey.shade300),
                                                  bottom: BorderSide(color: Colors.grey.shade300),
                                                ),
                                                columnWidths: const {
                                                  0: FlexColumnWidth(2),
                                                  1: FlexColumnWidth(1),
                                                  2: FlexColumnWidth(1.5),
                                                  3: FlexColumnWidth(1.5),
                                                  4: FlexColumnWidth(1.5),
                                                },
                                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                children: [
                                                  TableRow(
                                                    decoration: const BoxDecoration(
                                                      color: ColorConstants.ubtsBlue,
                                                    ),
                                                    children: [
                                                      _buildHeaderCell("Name"),
                                                      _buildHeaderCell("Qty", isCenter: true),
                                                      _buildHeaderCell("Status"),
                                                      _buildHeaderCell("Location"),
                                                      _buildHeaderCell("Action"),
                                                    ],
                                                  ),

                                                  ...items.map((item) {
                                                    return TableRow(
                                                      children: [
                                                        _buildBodyCell(item.name),
                                                        _buildBodyCell(item.quantity.toString(), isCenter: true),
                                                        _buildBodyCell(item.status),
                                                        _buildBodyCell(item.location),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: ElevatedButton(
                                                            style: ButtonStyle(

                                                              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                                if (states.contains(WidgetState.hovered) ||
                                                                    states.contains(WidgetState.pressed)) {
                                                                  return ColorConstants.ubtsBlue;
                                                                }
                                                                return ColorConstants.ubtsYellow;
                                                              }),
                                                              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                                if (states.contains(WidgetState.hovered) ||
                                                                    states.contains(WidgetState.pressed)) {
                                                                  return Colors.white;
                                                                }
                                                                return Colors.black;
                                                              }),
                                                            ),

                                                              
                                                              onPressed: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => InventoryDetailsPopup(item: item),
                                                                );
                                                              },
                                                              child: const Text("View"),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Desktopsidebar(),
          ),
        ],
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
            Text(
              "Created At: ${item.createdAt.toLocal().toString().split('.')[0]}",
            ),
            const SizedBox(height: 8),
            Text(
              "Updated At: ${item.updatedAt.toLocal().toString().split('.')[0]}",
            ),
            const SizedBox(height: 8),
            if (item.deletedAt != null)
              Text(
                "Deleted At: ${item.deletedAt!.toLocal().toString().split('.')[0]}",
              ),
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


