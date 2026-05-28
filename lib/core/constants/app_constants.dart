/// App-wide constant values for spacing, sizing, and border radius
class AppSizes {
  AppSizes._();

  // ── Border Radius ─────────────────────────────────────────
  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 999.0;

  // ── Spacing ───────────────────────────────────────────────
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // ── Icon Sizes ────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ── Card ──────────────────────────────────────────────────
  static const double cardElevation = 0.0;
  static const double cardPadding = 16.0;

  // ── Bottom Nav ────────────────────────────────────────────
  static const double bottomNavHeight = 72.0;

  // ── App Bar ───────────────────────────────────────────────
  static const double appBarHeight = 64.0;
}

/// App route path constants
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String medicines = '/medicines';
  static const String addMedicine = '/medicines/add';
  static const String editMedicine = '/medicines/edit';
  static const String medicineDetail = '/medicines/detail';
  static const String scanner = '/scanner';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String family = '/family';
  static const String disposal = '/disposal';
  static const String scanHistory = '/scan-history';
  static const String prescriptionAnalyzer = '/prescription-analyzer';
}

/// App-wide string constants
class AppStrings {
  AppStrings._();

  // ── App Info ──────────────────────────────────────────────
  static const String appName = 'MedTrack';
  static const String appTagline = 'Smart Medicine Expiry Tracker';

  // ── Auth ──────────────────────────────────────────────────
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String continueWithGoogle = 'Continue with Google';
  static const String forgotPassword = 'Forgot Password?';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";

  // ── Dashboard ─────────────────────────────────────────────
  static const String dashboard = 'Dashboard';
  static const String totalMedicines = 'Total';
  static const String safe = 'Safe';
  static const String expiringSoon = 'Expiring Soon';
  static const String expired = 'Expired';
  static const String expiryRiskScore = 'Expiry Risk Score';
  static const String byCategory = 'By Category';
  static const String monthlyTrend = 'Monthly Expiry Trend';
  static const String upcomingExpirations = 'Upcoming Expirations';

  // ── Medicines ─────────────────────────────────────────────
  static const String medicines = 'My Medicines';
  static const String addMedicine = 'Add Medicine';
  static const String medicineName = 'Medicine Name';
  static const String category = 'Category';
  static const String expiryDate = 'Expiry Date';
  static const String manufacturingDate = 'Manufacturing Date';
  static const String shelfLife = 'Shelf Life (months)';
  static const String scanToFill = 'Scan Dates on Pack';
  static const String saveChanges = 'Save Changes';
  static const String deleteMedicine = 'Delete Medicine';

  // ── Scanner ───────────────────────────────────────────────
  static const String scanner = 'Scan Medicine';
  static const String scannerHint = 'Point at the expiry date on the pack';
  static const String ocrProcessing = 'Detecting date...';
  static const String ocrSuccess = 'Date Found!';
  static const String ocrNoResult = 'No date detected. Try again or enter manually.';
  static const String mockScanMode = 'Demo Mode';

  // ── Notifications ─────────────────────────────────────────
  static const String notifications = 'Notifications';
  static const String reminder30 = '30 days before expiry';
  static const String reminder7 = '7 days before expiry';
  static const String reminderOnDay = 'On expiry day';
  static const String dailySummary = 'Daily 8 PM Summary';

  // ── Errors ────────────────────────────────────────────────
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String authError = 'Authentication failed. Check your credentials.';
}
