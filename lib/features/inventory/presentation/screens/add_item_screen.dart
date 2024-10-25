// lib/features/inventory/presentation/screens/inventory_add_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/inventory_item.dart';
import '../providers/inventory_provider.dart';
import '../widgets/inventory_item_form.dart';

class InventoryAddScreen extends ConsumerStatefulWidget {
  final InventoryItem? item;

  const InventoryAddScreen({
    super.key,
    this.item,
  });

  @override
  ConsumerState<InventoryAddScreen> createState() => _InventoryAddScreenState();
}

class _InventoryAddScreenState extends ConsumerState<InventoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: InventoryItemForm(
        formKey: _formKey,
        initialData: widget.item,
        isLoading: _isLoading,
        submitButtonText: widget.item == null ? 'Add Item' : 'Update Item',
        onSubmit: (formData) async {
          setState(() => _isLoading = true);

          try {
            if (widget.item == null) {
              final newItem = formData.toInventoryItem(const Uuid().v4());
              await ref.read(inventoryItemsProvider.notifier).addItem(newItem);
            } else {
              final updatedItem = formData.toInventoryItem(widget.item!.id);
              await ref
                  .read(inventoryItemsProvider.notifier)
                  .updateItem(updatedItem);
            }
            if (mounted) {
              Navigator.pop(context);
            }
          } finally {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          }
        },
      ),
    );
  }
}