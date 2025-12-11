/// Application Configuration File
/// This file contains various configuration settings for the application.
/// It includes app identity, asset paths, API settings, theme colors, and feature flags. 
/// Add or modify the values as needed for your application. 
/// const Map<String, dynamic> configList = { ... };
final Map<String, dynamic> configList = {
    /// App identity
    'appName': 'NestHub Global Ltd',
    'appLogoPath': 'public/assets/logo/svg/logo.svg',

    /// Base asset paths
    'BasePaths': {
        'public': 'public/assets/',
        'images': 'public/assets/images/',
        'icons': 'public/assets/icons/',
        'logos': 'public/assets/logo/',
    },

    /// API
    'apiBaseUrl': 'https:///api.daphascomp.com/v1/',
    'timeoutSeconds': 30,

    /// Theme colors - UI Customization...
    'primaryColorHex': '#4CAF50',
    'secondaryColorHex': '#FF9800',
    
    /// Feature flags - enable or disable features
    'enableDebug': true,
    'enableLogging': true,

    /// Other assets
    'defaultAvatar': 'public/assets/avatars/default-avatar.png',
    'onboardingImages': [
        'public/assets/images/onboarding1.png',
        'public/assets/images/onboarding2.png',
        'public/assets/images/onboarding3.png',
    ],
};
