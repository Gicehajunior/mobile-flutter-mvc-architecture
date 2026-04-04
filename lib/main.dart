import 'package:flutter/material.dart';
import 'package:nexus/public/index.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

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