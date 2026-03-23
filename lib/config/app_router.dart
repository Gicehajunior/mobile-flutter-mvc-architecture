import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:mvcflutter/config/view_factory.dart';
import 'package:mvcflutter/config/view_request.dart';
import 'package:mvcflutter/config/app_request.dart';

class AppRouter {
  final List<GoRoute> _routes = [];

  /// Registers a route in the router system.
  ///
  /// @param [path] The URL path for the route.
  /// @param [name] An identifier for the route.
  /// @param [controllerRequest] A function that will be executed when this route is accessed.
  void route(String path, String name, dynamic Function(Request request) controllerRequest) {
    _routes.add(
      GoRoute(
        path: path,
        name: name,
        builder: (context, state) {
          final request = Request(state); 
          final result = controllerRequest(request); 

          // Extract path parameters from the route
          final pathParams = state.pathParameters;
          
          // Extract query parameters from the route
          final queryParams = state.uri.queryParameters;
          
          // Combine all route parameters
          final routeData = {
            ...pathParams,
            ...queryParams,
          };

          // Handle ViewRequest
          if (result is ViewRequest) {
            // If request already has data, merge with route parameters
            // If request has no data, use route parameters as data
            final Map<String, dynamic>? requestData = result.data;
            final Map<String, dynamic> mergedData = requestData != null 
                ? {...requestData, ...routeData}
                : routeData;
            
            // Create updated request with correct constructor format
            final updatedRequest = mergedData.isNotEmpty
                ? ViewRequest(result.key, data: mergedData)
                : ViewRequest(result.key);
              
            return ViewFactory.createView(updatedRequest);
          }

          // directly return widget
          if (result is Widget) {
            return result;
          }

          return result as Widget? ??
              Center(
                child: Text("Route returned non-widget data: $result"),
              );
        },
      ),
    );
  }

  /// Builds and returns a GoRouter instance.
  /// The router provider gets to call this function on the process of executing
  /// the a specific route.
  ///
  /// @param [initialLocation] The initial route location (defaults to '/').
  /// @return [GoRouter] A GoRouter configured with the defined routes.
  GoRouter build({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: _routes,
    );
  }
}
