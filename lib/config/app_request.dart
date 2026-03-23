import 'package:go_router/go_router.dart';

/// A lightweight abstraction over GoRouterState that 
/// treats route parameters and query parameters uniformly,
/// allowing the developer to access request-like data in a 
/// familiar GET/POST style. Think of it as a mini HTTP request 
/// object for your in-app routing.
class Request {
  final Map<String, String> params;
  final Map<String, String> query;
  final String path;
  final GoRouterState state;

  Request(this.state)
      : params = state.pathParameters,
        query = state.uri.queryParameters,
        path = state.uri.path;

  /// Helper to get a value from either 
  /// query or params (POST/GET style)
  String? input(String key) {
    return query[key] ?? params[key];
  }

  /// Get all data merged into one Map
  Map<String, dynamic> all() {
    return {...params, ...query};
  }
}