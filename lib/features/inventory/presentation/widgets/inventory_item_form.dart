// lib/features/inventory/presentation/widgets/inventory_item_form.dart  

import 'package:flutter/material.dart';  
import 'package:flutter/services.dart';  
import '../../data/models/inventory_item.dart';  
import '../../../../core/constants/app_constants.dart';  
import '../../../../shared/widgets/custom_text_field.dart';  

class InventoryItemForm extends StatefulWidget {  
  final GlobalKey<FormState> formKey;  
  final InventoryItem? initialData;  
  final bool isLoading;  
  final String submitButtonText;  
  final Future<void> Function(InventoryItemFormData) onSubmit;  

  const InventoryItemForm({  
    Key? key,  
    required this.formKey,  
    this.initialData,  
    required this.isLoading,  
    required this.submitButtonText,  
    required this.onSubmit,  
  }) : super(key: key);  

  @override  
  State<InventoryItemForm> createState() => _InventoryItemFormState();  
}  

class _InventoryItemFormState extends State<InventoryItemForm> {  
  late final TextEditingController _nameController;  
  late final TextEditingController _quantityController;  
  late final TextEditingController _priceController;  
  late final TextEditingController _descriptionController;  
  
  late final FocusNode _nameFocus;  
  late final FocusNode _quantityFocus;  
  late final FocusNode _priceFocus;  
  late final FocusNode _descriptionFocus;  

  @override  
  void initState() {  
    super.initState();  
    _initializeControllers();  
    _initializeFocusNodes();  
  }  

  void _initializeControllers() {  
    _nameController = TextEditingController(text: widget.initialData?.name);  
    _quantityController = TextEditingController(  
      text: widget.initialData?.quantity.toString(),  
    );  
    _priceController = TextEditingController(  
      text: widget.initialData?.price.toStringAsFixed(2),  
    );  
    _descriptionController = TextEditingController(  
      text: widget.initialData?.description,  
    );  
  }  

  void _initializeFocusNodes() {  
    _nameFocus = FocusNode();  
    _quantityFocus = FocusNode();  
    _priceFocus = FocusNode();  
    _descriptionFocus = FocusNode();  
  }  

  @override  
  void dispose() {  
    _nameController.dispose();  
    _quantityController.dispose();  
    _priceController.dispose();  
    _descriptionController.dispose();  
    
    _nameFocus.dispose();  
    _quantityFocus.dispose();  
    _priceFocus.dispose();  
    _descriptionFocus.dispose();  
    
    super.dispose();  
  }  

  Future<void> _handleSubmit() async {  
    if (widget.formKey.currentState!.validate()) {  
      final formData = InventoryItemFormData(  
        name: _nameController.text.trim(),  
        quantity: int.parse(_quantityController.text),  
        price: double.parse(_priceController.text),  
        description: _descriptionController.text.trim(),  
      );  

      try {  
        await widget.onSubmit(formData);  
      } catch (e) {  
        if (mounted) {  
          ScaffoldMessenger.of(context).showSnackBar(  
            SnackBar(  
              content: Text('Error: ${e.toString()}'),  
              backgroundColor: Theme.of(context).colorScheme.error,  
            ),  
          );  
        }  
      }  
    }  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Form(  
      key: widget.formKey,  
      child: ListView(  
        padding: const EdgeInsets.all(16),  
        children: [  
          CustomTextField(  
            label: 'Item Name',  
            controller: _nameController,  
            focusNode: _nameFocus,  
            textInputAction: TextInputAction.next,  
            onFieldSubmitted: (_) {  
              FocusScope.of(context).requestFocus(_quantityFocus);  
            },  
            validator: (value) {  
              if (value == null || value.isEmpty) {  
                return 'Please enter an item name';  
              }  
              if (value.length < 2) {  
                return 'Name must be at least 2 characters';  
              }  
              if (value.length > AppConstants.maxNameLength) {  
                return 'Name must be less than ${AppConstants.maxNameLength} characters';  
              }  
              return null;  
            },  
          ),  
          const SizedBox(height: 16),  
          Row(  
            children: [  
              Expanded(  
                child: CustomTextField(  
                  label: 'Quantity',  
                  controller: _quantityController,  
                  focusNode: _quantityFocus,  
                  textInputAction: TextInputAction.next,  
                  keyboardType: TextInputType.number,  
                  inputFormatters: [  
                    FilteringTextInputFormatter.digitsOnly,  
                    LengthLimitingTextInputFormatter(5),  
                  ],  
                  onFieldSubmitted: (_) {  
                    FocusScope.of(context).requestFocus(_priceFocus);  
                  },  
                  validator: (value) {  
                    if (value == null || value.isEmpty) {  
                      return 'Required';  
                    }  
                    final quantity = int.tryParse(value);  
                    if (quantity == null) {  
                      return 'Invalid number';  
                    }  
                    if (quantity < 0) {  
                      return 'Must be ≥ 0';  
                    }  
                    if (quantity > AppConstants.maxQuantity) {  
                      return 'Must be ≤ ${AppConstants.maxQuantity}';  
                    }  
                    return null;  
                  },  
                ),  
              ),  
              const SizedBox(width: 16),  
              Expanded(  
                child: CustomTextField(  
                  label: 'Price',  
                  controller: _priceController,  
                  focusNode: _priceFocus,  
                  textInputAction: TextInputAction.next,  
                  keyboardType: const TextInputType.numberWithOptions(  
                    decimal: true,  
                  ),  
                  inputFormatters: [  
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),  
                    LengthLimitingTextInputFormatter(10),  
                  ],  
                  onFieldSubmitted: (_) {  
                    FocusScope.of(context).requestFocus(_descriptionFocus);  
                  },  
                  validator: (value) {  
                    if (value == null || value.isEmpty) {  
                      return 'Required';  
                    }  
                    final price = double.tryParse(value);  
                    if (price == null) {  
                      return 'Invalid price';  
                    }  
                    if (price < 0) {  
                      return 'Must be ≥ 0';  
                    }  
                    if (price > AppConstants.maxPrice) {  
                      return 'Must be ≤ ${AppConstants.maxPrice}';  
                    }  
                    return null;  
                  },  
                ),  
              ),  
            ],  
          ),  
          const SizedBox(height: 16),  
          CustomTextField(  
            label: 'Description',  
            controller: _descriptionController,  
            focusNode: _descriptionFocus,  
            isMultiline: true,  
            maxLines: 4,  
            textInputAction: TextInputAction.newline,  
            validator: (value) {  
              if (value != null && value.length > AppConstants.maxDescriptionLength) {  
                return 'Description must be less than ${AppConstants.maxDescriptionLength} characters';  
              }  
              return null;  
            },  
          ),  
          const SizedBox(height: 24),  
          ElevatedButton(  
            onPressed: widget.isLoading ? null : _handleSubmit,  
            style: ElevatedButton.styleFrom(  
              padding: const EdgeInsets.symmetric(vertical: 16),  
            ),  
            child: widget.isLoading  
                ? const SizedBox(  
                    height: 20,  
                    width: 20,  
                    child: CircularProgressIndicator(  
                      strokeWidth: 2,  
                    ),  
                  )  
                : Text(widget.submitButtonText),  
          ),  
        ],  
      ),  
    );  
  }  
}  

// Form Data class to handle form submission  
class InventoryItemFormData {  
  final String name;  
  final int quantity;  
  final double price;  
  final String description;  

  const InventoryItemFormData({  
    required this.name,  
    required this.quantity,  
    required this.price,  
    required this.description,  
  });  

  // Convert form data to InventoryItem model  
  InventoryItem toInventoryItem(String id) {  
    return InventoryItem(  
      id: id,  
      name: name,  
      quantity: quantity,  
      price: price,  
      description: description,  
    );  
  }  
}  

// Extension to update Add and Edit Item screens  
extension InventoryItemFormUsage on InventoryItem {  
  InventoryItemFormData toFormData() {  
    return InventoryItemFormData(  
      name: name,  
      quantity: quantity,  
      price: price,  
      description: description,  
    );  
  }  
}  
