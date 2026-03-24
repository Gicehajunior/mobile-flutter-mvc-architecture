import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application Configuration File
/// This file contains various configuration settings for the application.
/// It includes app identity, asset paths, API settings, theme colors, and feature flags.
/// Add or modify the values as needed for your application.
/// `const Map<String, dynamic> configList = { ... };`
final Map<String, dynamic> configList = {
  // App identity
  'appName': dotenv.env['APP_NAME'] ?? 'MVC Application',
  'appEnv': dotenv.env['APP_ENV'] ?? 'production',
  'appVersion': dotenv.env['APP_VERSION'] ?? '1.0.0',
  'clientToken': 'f7a1b2c3d4e5f67890abcd1234567890abcdef1234567890abcdef1234567890',
  
  'appLogoPath': 'public/assets/logo/svg/nesthub-logo.svg',

  // Base asset paths
  'BasePaths': {
    'public': 'public/assets/',
    'images': 'public/assets/images/',
    'icons': 'public/assets/icons/',
    'logos': 'public/assets/logo/',
  },

  // API
  'apiBaseUrl': dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8200/v1',
  'timeoutSeconds': int.tryParse(dotenv.env['TIMEOUT_SECONDS'] ?? '30') ?? 30,
  'apiKey': dotenv.env['API_KEY'] ?? '',
  'apiSecret': dotenv.env['API_SECRET'] ?? '',
  'jwtSecret': dotenv.env['JWT_SECRET'] ?? '',
  'tokenExpiry': int.tryParse(dotenv.env['TOKEN_EXPIRY'] ?? '3600') ?? 3600,

  // Theme / UI
  'primaryColorHex': '#4CAF50', // green
  'secondaryColorHex': '#FF9800', // orange

  // Feature flags
  'enableDebug':
      dotenv.env['APP_DEBUG']?.toLowerCase() == 'true' ? true : false,
  'enableLogging':
      dotenv.env['APP_LOGGING']?.toLowerCase() == 'true' ? true : false,

  // Other assets
  'defaultAvatar': 'public/assets/images/default-avatar.png',
  'onboardingImages': [
    'public/assets/images/onboarding1.png',
    'public/assets/images/onboarding2.png',
    'public/assets/images/onboarding3.png',
  ],
};
