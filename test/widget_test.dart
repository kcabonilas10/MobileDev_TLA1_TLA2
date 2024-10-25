// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_system/features/inventory/data/models/inventory_item.dart';
import 'package:inventory_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:inventory_system/features/inventory/presentation/screens/inventory_screen.dart';


void main() {
  testWidgets('InventoryScreen shows loading state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('InventoryScreen shows empty state message', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('No items in inventory'), findsOneWidget);
    expect(find.text('Tap the + button to add items'), findsOneWidget);
  });

  testWidgets('InventoryScreen shows items when available', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Add test items
    final testItems = [
      const InventoryItem(
        id: '1',
        name: 'Test Item 1',
        description: 'Description 1',
        quantity: 10,
        price: 9.99,
      ),
      const InventoryItem(
        id: '2',
        name: 'Test Item 2',
        description: 'Description 2',
        quantity: 5,
        price: 19.99,
      ),
    ];

    // Override the provider with test data
    container.read(inventoryItemsProvider.notifier).state = AsyncData(testItems);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify items are displayed
    expect(find.text('Test Item 1'), findsOneWidget);
    expect(find.text('Test Item 2'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
    expect(find.text('Description 2'), findsOneWidget);
  });

  testWidgets('InventoryScreen shows error state', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Set error state
    container.read(inventoryItemsProvider.notifier).state = 
        AsyncError('Test error', StackTrace.empty);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Error loading inventory'), findsOneWidget);
    expect(find.text('RETRY'), findsOneWidget);
  });
}