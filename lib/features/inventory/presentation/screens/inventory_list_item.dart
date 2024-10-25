// lib/features/inventory/presentation/widgets/inventory_list_item.dart

import 'package:flutter/material.dart';
import '../../data/models/inventory_item.dart';
import '../screens/edit_inventory_item_screen.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onDelete;

  const InventoryListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditInventoryItemScreen(item: item),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Item'),
                        content: Text(
                          'Are you sure you want to delete "${item.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDelete();
                              Navigator.pop(context);
                            },
                            child: const Text('DELETE'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity: ${item.quantity}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Price: \$${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}