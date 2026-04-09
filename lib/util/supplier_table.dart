/*
import 'package:flutter/material.dart';
import '../model/supplier.dart';

class SupplierTable extends StatelessWidget {
  final List<Supplier> suppliers;
  
  const SupplierTable({
    super.key,
    required this.suppliers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suppliers List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,//scroll horizontal
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32,
                ),
                child: DataTable(
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Created', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: suppliers.map((supplier) => DataRow(
                    cells: [
                      DataCell(Text(supplier.id.toString())),
                      DataCell(Text(supplier.name)),
                      DataCell(Text(supplier.phone)),
                      DataCell(Text(supplier.email)),
                      DataCell(Text(supplier.address)),
                      DataCell(Text(supplier.createdAt)),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/