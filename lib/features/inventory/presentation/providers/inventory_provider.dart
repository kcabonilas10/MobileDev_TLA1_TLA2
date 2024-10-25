import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inventory_item.dart';

final inventoryItemsProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<List<InventoryItem>>>((ref) {
  return InventoryNotifier();
});

class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  InventoryNotifier() : super(const AsyncValue.loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = const AsyncValue.loading();
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data([]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addItem(InventoryItem item) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data([...currentItems, item]);
  }

  Future<void> updateItem(InventoryItem updatedItem) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data(
      currentItems.map((item) => item.id == updatedItem.id ? updatedItem : item).toList(),
    );
  }

  Future<void> deleteItem(String id) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data(
      currentItems.where((item) => item.id != id).toList(),
    );
  }
}