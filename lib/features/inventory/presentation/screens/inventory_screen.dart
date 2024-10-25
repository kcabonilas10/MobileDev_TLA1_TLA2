// lib/features/inventory/presentation/screens/inventory_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';
import '../widgets/inventory_item_card.dart';
import 'edit_inventory_item_screen.dart';
import '../../data/models/inventory_item.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  quantityAsc,
  quantityDesc,
}

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  SortOption _currentSort = SortOption.nameAsc;

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Name (A-Z)'),
              leading: Radio<SortOption>(
                value: SortOption.nameAsc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.nameAsc),
            ),
            ListTile(
              title: const Text('Name (Z-A)'),
              leading: Radio<SortOption>(
                value: SortOption.nameDesc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.nameDesc),
            ),
            ListTile(
              title: const Text('Price (Low to High)'),
              leading: Radio<SortOption>(
                value: SortOption.priceAsc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.priceAsc),
            ),
            ListTile(
              title: const Text('Price (High to Low)'),
              leading: Radio<SortOption>(
                value: SortOption.priceDesc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.priceDesc),
            ),
            ListTile(
              title: const Text('Quantity (Low to High)'),
              leading: Radio<SortOption>(
                value: SortOption.quantityAsc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.quantityAsc),
            ),
            ListTile(
              title: const Text('Quantity (High to Low)'),
              leading: Radio<SortOption>(
                value: SortOption.quantityDesc,
                groupValue: _currentSort,
                onChanged: _handleSortChange,
              ),
              onTap: () => _handleSortChange(SortOption.quantityDesc),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  void _handleSortChange(SortOption? value) {
    if (value != null) {
      setState(() => _currentSort = value);
      Navigator.pop(context);
    }
  }

  List<InventoryItem> _sortItems(List<InventoryItem> items) {
    final sortedItems = List<InventoryItem>.from(items);
    switch (_currentSort) {
      case SortOption.nameAsc:
        sortedItems.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.nameDesc:
        sortedItems.sort((a, b) => b.name.compareTo(a.name));
      case SortOption.priceAsc:
        sortedItems.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        sortedItems.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.quantityAsc:
        sortedItems.sort((a, b) => a.quantity.compareTo(b.quantity));
      case SortOption.quantityDesc:
        sortedItems.sort((a, b) => b.quantity.compareTo(a.quantity));
    }
    return sortedItems;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(inventoryItemsProvider.notifier).loadItems();
            },
          ),
        ],
      ),
      body: inventoryState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error loading inventory',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref.read(inventoryItemsProvider.notifier).loadItems();
                },
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
                  Text(
                    'No items in inventory',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add items',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final sortedItems = _sortItems(items);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedItems.length,
            itemBuilder: (context, index) {
              final item = sortedItems[index];
              return InventoryItemCard(
                item: item,
                onDelete: () {
                  ref.read(inventoryItemsProvider.notifier).deleteItem(item.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditInventoryItemScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}