// lib/core/constants/app_constants.dart

class AppConstants {
  // Form Validation
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxQuantity = 99999;
  static const double maxPrice = 999999.99;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  
  // Database
  static const String dbName = 'inventory.db';
  static const int dbVersion = 1;
}