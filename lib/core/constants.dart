class AppConstants {
  // App info
  static const String appName = 'ScamShield';
  static const String appTagline = 'Shop Safe. Shop Smart.';

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String reportsCollection = 'reports';

  // Trust score thresholds
  static const double safeScore = 70.0;
  static const double cautionScore = 40.0;

  // Trust score colors
  static const int safeColorValue = 0xFF16A34A;     // green
  static const int cautionColorValue = 0xFFF59E0B;  // amber
  static const int dangerColorValue = 0xFFDC2626;   // red

  // Gemini
  static const String geminiModel = 'gemini-1.5-flash';

  // Status values
  static const String statusPending = 'pending';
  static const String statusAnalyzed = 'analyzed';
  static const String statusFailed = 'failed';
}