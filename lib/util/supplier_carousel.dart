import 'package:flutter/material.dart';
import '../model/supplier.dart';

class SupplierCarousel extends StatefulWidget {
  final List<Supplier> suppliers;

  const SupplierCarousel({
    super.key,
    required this.suppliers,
  });

  @override
  State<SupplierCarousel> createState() => _SupplierCarouselState();
}

class _SupplierCarouselState extends State<SupplierCarousel> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredSuppliers = widget.suppliers.where((supplier) {
      return supplier.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 600 ? 0 : 8,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search supplier",
              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
              ),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: MediaQuery.of(context).size.width < 400 ? 8 : 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        
        if (filteredSuppliers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredSuppliers.length} suppliers found',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Responsive Carousel
        Expanded(
          child: filteredSuppliers.isEmpty
              ? const Center(child: Text('No suppliers found'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double viewportFraction = 0.85;
                    if (constraints.maxWidth < 400) {
                      viewportFraction = 0.9;
                    } else if (constraints.maxWidth > 800) {
                      viewportFraction = 0.7;
                    }
                    
                    return PageView.builder(
                      controller: PageController(viewportFraction: viewportFraction),
                      itemCount: filteredSuppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = filteredSuppliers[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth < 400 ? 4 : 8,
                          ),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                constraints.maxWidth < 400 ? 12 : 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    supplier.name,
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth < 400 ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  
                                  _buildResponsiveInfoRow(
                                    icon: Icons.phone,
                                    iconColor: Colors.green,
                                    label: "Phone",
                                    value: supplier.phone,
                                    constraints: constraints,
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  _buildResponsiveInfoRow(
                                    icon: Icons.email,
                                    iconColor: Colors.blue,
                                    label: "Email",
                                    value: supplier.email,
                                    constraints: constraints,
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  _buildResponsiveInfoRow(
                                    icon: Icons.location_on,
                                    iconColor: Colors.orange,
                                    label: "Location",
                                    value: supplier.address,
                                    constraints: constraints,
                                    isAddress: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildResponsiveInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required BoxConstraints constraints,
    bool isAddress = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: constraints.maxWidth < 400 ? 14 : 16, color: iconColor),
        SizedBox(width: constraints.maxWidth < 400 ? 6 : 8),
        Expanded(
          child: Text(
            "$label: $value",
            style: TextStyle(
              fontSize: constraints.maxWidth < 400 ? 12 : 14,
            ),
            maxLines: isAddress ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}