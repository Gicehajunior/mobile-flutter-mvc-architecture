import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:mvcflutter/config/app_logger.dart';
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

          // Check if the controller returned a Future (Async)
          if (result is Future) {
            return FutureBuilder(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  Log.error("Router Async Error: ${snapshot.error}");
                  return Scaffold(
                    body: Center(child: Text("Error: ${snapshot.error}")),
                  );
                }

                // Process the resolved result once the Future completes
                return _processResult(snapshot.data, state);
              },
            );
          }

          // Handle Sync results immediately
          return _processResult(result, state);
        },
      ),
    );
  }

  /// Handle ViewRequest and Widget results gracefully!
  Widget _processResult(dynamic result, GoRouterState state) {
    final pathParams = state.pathParameters;
    final queryParams = state.uri.queryParameters;
    
    final routeData = {
      ...pathParams,
      ...queryParams,
    };

    if (result is ViewRequest) {
      final Map<String, dynamic>? requestData = result.data;
      final Map<String, dynamic> mergedData = requestData != null 
          ? {...requestData, ...routeData}
          : routeData;
      
      Log.debug("DATA SNAPSHOT RESPONSE FROM THE REQUEST ENTITY: $mergedData");

      final updatedRequest = mergedData.isNotEmpty
          ? ViewRequest(result.key, data: mergedData)
          : ViewRequest(result.key);
      
      return ViewFactory.createView(updatedRequest);
    }

    if (result is Widget) {
      return result;
    }

    // Final fallback to avoid casting errors
    return Scaffold(
      body: Center(
        child: Text("Route error: Expected Widget or ViewRequest, got $result"),
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
