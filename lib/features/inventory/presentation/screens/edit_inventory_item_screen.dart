// lib/features/inventory/presentation/screens/edit_inventory_item_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inventory_item.dart';
import '../providers/inventory_provider.dart';

class EditInventoryItemScreen extends ConsumerStatefulWidget {
  final InventoryItem? item;

  const EditInventoryItemScreen({
    super.key,
    this.item,
  });

  @override
  ConsumerState<EditInventoryItemScreen> createState() => _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends ConsumerState<EditInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _descriptionController = TextEditingController(text: widget.item?.description);
    _quantityController = TextEditingController(
      text: widget.item?.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.item?.price.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) return;

    final item = InventoryItem(
      id: widget.item?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      quantity: int.parse(_quantityController.text),
      price: double.parse(_priceController.text),
    );

    if (_isEditing) {
      ref.read(inventoryItemsProvider.notifier).updateItem(item);
    } else {
      ref.read(inventoryItemsProvider.notifier).addItem(item);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item' : 'Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saveItem,
              child: Text(_isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}