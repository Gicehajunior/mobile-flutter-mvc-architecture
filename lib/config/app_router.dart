import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvcflutter/config/view_factory.dart';
import 'package:mvcflutter/config/view_request.dart';

class AppRouter {
	final List<GoRoute> _routes = [];
	
	void route(String path, String name, dynamic Function() controllerRequest) {
		_routes.add(
			GoRoute(
				path: path,
				name: name,
				builder: (context, state) {
					final result = controllerRequest();
					print("REQUEST PRINT ROUTER TRAIL: $result");
					
					// render widget
					if (result is MVCFRequest) {
						return ViewFactory.createView(result);
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
	
	GoRouter build({String initialLocation = '/'}) {
		return GoRouter(
			initialLocation: initialLocation,
			routes: _routes,
		);
	}
}
