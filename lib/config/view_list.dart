import 'package:flutter/material.dart';
import 'package:nexus/presentation/screens/auth/login_screen.dart';
import 'package:nexus/presentation/screens/auth/forgot_password.dart';
import 'package:nexus/presentation/screens/home/home_screen.dart';

// A mapping of view keys to their corresponding widget constructors.
// Add the data params on the screen class constructors accordingly, i.e if 
// the screen requires parameters, ensure to pass them via the data map.
// sometimes returns data which can be null hence the Map<String, dynamic>? type.
final Map<String, Widget Function(Map<String, dynamic>? data)> viewsList = {
    // Home screen mappings
    'home/home_screen': (data) => HomeScreen(data: data ?? {}),

    // Auth screen mappings
    'auth/login_screen': (data) => LoginScreen(),
    'auth/forgot_password': (data) => ForgotPassword(),

    // add more screens mapping below...
};