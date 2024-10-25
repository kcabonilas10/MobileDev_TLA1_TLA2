import 'package:flutter/material.dart';
import '../../data/models/inventory_item.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const InventoryListItem({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 4),
            Text(
              'Quantity: ${item.quantity} • Price: \$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}