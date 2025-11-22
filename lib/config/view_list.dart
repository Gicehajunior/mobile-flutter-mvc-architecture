import 'package:flutter/material.dart';
import 'package:mvcflutter/presentation/screens/auth/login_screen.dart';
import 'package:mvcflutter/presentation/screens/home/home_screen.dart';

final Map<String, Widget Function()> viewsList = {
    'auth/login_screen': () => const LoginScreen(),
    'home/home_screen': () => const HomeScreen(),

    // add more screens mapping below...
};