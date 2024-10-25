import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';
import '../widgets/inventory_list_item.dart';
import '../widgets/add_item_dialog.dart';

class InventoryListScreen extends ConsumerWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: inventoryState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading inventory'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(inventoryItemsProvider),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No items in inventory',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add items',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InventoryListItem(
                item: item,
                onTap: () {
                  // TODO: Implement view item details
                },
                onEdit: () {
                  // TODO: Implement edit item
                },
                onDelete: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Item'),
                      content: const Text('Are you sure you want to delete this item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    ref.read(inventoryItemsProvider.notifier).deleteItem(item.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await showDialog(
            context: context,
            builder: (context) => const AddItemDialog(),
          );
          
          if (newItem != null) {
            ref.read(inventoryItemsProvider.notifier).addItem(newItem);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}