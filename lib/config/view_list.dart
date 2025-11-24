import 'package:flutter/material.dart';
import 'package:mvcflutter/presentation/screens/auth/login_screen.dart';
import 'package:mvcflutter/presentation/screens/auth/forgot_password.dart';
import 'package:mvcflutter/presentation/screens/home/home_screen.dart';

final Map<String, Widget Function()> viewsList = {
    'auth/login_screen': () => LoginScreen(),
    'auth/forgot_password': () => ForgotPassword(),
    'home/home_screen': () => HomeScreen(),

    // add more screens mapping below...
};