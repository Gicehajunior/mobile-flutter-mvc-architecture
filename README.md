# Mobile MVC architecture - Flutter, MVCF

## Overview
Welcome gorgeous! This project is a comprehensive Flutter application built using the Model-View-Controller (MVC) architecture. It provides a robust framework for developing mobile applications with a clean separation of concerns, making it easier to manage and scale your codebase.

### Key Features
- **MVC Architecture**: Clear separation of concerns between models, views, and controllers.
- **Flutter Integration**: Leverages the power of Flutter for building beautiful, high-performance mobile applications.
- **Firebase Integration**: Seamless integration with Firebase for authentication, database, and other cloud services.
- **Extensive Documentation**: Comprehensive documentation to help you get started quickly.

### Who This Project Is For
- Developers looking to build scalable and maintainable mobile applications.
- Teams that want to leverage the MVC architecture for better code organization.
- Flutter enthusiasts who want to explore advanced features and best practices.

## Features
- **Authentication**: Secure user authentication using Firebase.
- **Data Management**: Efficient data management with Firebase Firestore.
- **Cross-Platform**: Build once, run anywhere with Flutter.
- **State Management**: Efficient state management using Riverpod.
- **API Integration**: Easy integration with RESTful APIs using Dio.

## Tech Stack
- **Programming Language**: Dart
- **Frameworks and Libraries**:
  - Flutter
  - Firebase
  - Riverpod
  - Dio
  - GoRouter
  - Provider
- **System Requirements**:
  - Flutter SDK
  - Dart SDK
  - Android Studio (for Android development) or IDE of your choice i.e VSCode
  - Xcode (for iOS development)

## Installation

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio
- Xcode

### Quick Start
```bash
# Clone the repository
git clone https://github.com/Gicehajunior/mobile-flutter-mvc-architecture.git

# Navigate to the project directory
cd mobile-flutter-mvc-architecture

# Get dependencies
flutter pub get

# Run the application
flutter run
```

### Alternative Installation Methods
- **Docker**: You can use Docker to set up a development environment.
- **Package Managers**: Use package managers like `pub` to manage dependencies.

## Usage

### Basic Usage
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/public/index.dart'; 

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyApp app = MyApp();

  // Initialize services before 
  //running the app
  await app.initializeApp();

  // Run the app within ProviderScope for Riverpod 
  //state management
  runApp(const ProviderScope(child: MyApp()));
}
```

### Advanced Usage
- **Customizing Views**: You can customize the views by modifying the `viewsList` in `lib/config/view_list.dart`.
- **Adding New Screens**: Add new screens by defining them in `lib/config/view_list.dart` and creating their respective controllers.

## Project Structure
```
mobile-flutter-mvc-architecture/
├── android/
├── ios/
├── lib/
│   ├── app/
│   │   ├── controllers/
│   │   ├── providers/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── models/
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── app_logger.dart
│   │   ├── app_router.dart
│   │   ├── app_request.dart
│   │   ├── controller.dart
│   │   ├── mvc_exception.dart
│   │   ├── provider_registry.dart
│   │   ├── session_manager.dart
│   │   ├── view_factory.dart 
│   │   ├── view_list.dart
│   │   ├── view_request.dart
│   ├── features/
│   ├── main.dart
│   ├── presentation/
│   │   ├── screens/
│   │   ├── themes/
│   │   ├── widgets/
│   ├── public/
│   │   ├── repos/
│   │   │   ├── global/
│   │   │   ├── lang/
│   │   │   ├── methods/
│   │   │   ├── mobile/ 
│   │   ├── assets/
│   │   │   ├── avatars/
│   │   │   ├── images/
│   │   │   ├── logo/
│   │   │   ├── svg/ 
│   │   │   ├── videos/ 
│   │   ├── cache/
│   │   │   ├── xxx/ 
│   │   ├── storage/
│   │   │   ├── xxx/ 
│   │   ├── index.dart
│   ├── routes/
│   │   ├── app.dart
├── .editorconfig
├── .gitignore
├── README.md
├── analysis_options.yaml
├── devtools_options.yaml
├── pubspec.yaml
├── test/
│   ├── widget_test.dart
├── web/
├── windows/
└── linux/
```

## 🔧 Configuration
- **Environment Variables**: Set environment variables in `.env` file.
- **Configuration Files**: Configuration files are located in `lib/config/`.

## Contributing
We welcome contributions! Here's how you can get started:

### Development Setup
1. **Clone the Repository**
   ```bash
   git clone https://github.com/Gicehajunior/mobile-flutter-mvc-architecture.git
   cd mobile-flutter-mvc-architecture
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

### Code Style Guidelines
- Follow the Dart and Flutter coding conventions.
- Use meaningful variable and function names.
- Keep your code modular and maintainable.

### Pull Request Process
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your fork.
5. Open a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👥 Authors & Contributors
- **Maintainers**: [Bernard](https://github.com/Gicehajunior)
- **Contributors**: You and Me

## Issues & Support
- **Report Issues**: Open an issue on the GitHub repository.
- **Get Help**: Join the Flutter community on [Flutter.dev](https://flutter.dev) or [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter).

## Roadmap
- **Planned Features**:
  - Add support for more platforms (e.g., Windows, macOS).
  - Improve state management with Riverpod.
  - Enhance Firebase integration.
- **Known Issues**: [List of known issues](https://github.com/Gicehajunior/mobile-flutter-mvc-architecture/issues)
- **Future Improvements**: [List of future improvements](https://github.com/Gicehajunior/mobile-flutter-mvc-architecture/issues)

---

**Badges:** 
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/Gicehajunior/mobile-flutter-mvc-architecture/blob/main/.License)
[![Version](https://img.shields.io/badge/Version-1.0.0+1-blue.svg)](https://github.com/Gicehajunior/mobile-flutter-mvc-architecture/releases)

---

Getting started with the `mobile-flutter-mvc-architecture` project. Happy coding!