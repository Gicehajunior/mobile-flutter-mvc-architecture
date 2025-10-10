import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final List<GoRoute> _routes = [];

  void route(String path, String name, Widget screen) {
    _routes.add(
      GoRoute(
        path: path,
        name: name,
        builder: (context, state) => screen,
      ),
    );
  }

  GoRouter build({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: _routes,
    );
  }
}
