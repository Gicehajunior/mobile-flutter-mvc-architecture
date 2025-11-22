import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvcflutter/config/view_factory.dart';
import 'package:mvcflutter/config/view_request.dart';

typedef ControllerView = MVCFRequest Function();

class AppRouter {
	final List<GoRoute> _routes = [];
	
	void route(String path, String name, ControllerView controllerView) {
		_routes.add(
			GoRoute(
				path: path,
				name: name,
				builder: (context, state) {
					final request = controllerView();
					print("REQUEST PRINT ROUTER TRAIL: $request");
					final widget = ViewFactory.createView(request);
					return widget;
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
