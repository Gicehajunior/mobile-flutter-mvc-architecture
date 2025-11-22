import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/view_interface.dart';

class LoginScreen extends ConsumerWidget with DataReceivable {
	final String? email;

	// constructor
	const LoginScreen({super.key, this.email});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(
			appBar: AppBar(title: const Text('Login')),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						if (email != null) Text('Prefilled email: $email'),
						const SizedBox(height: 16),
						ElevatedButton(
							onPressed: () => context.go('/'),
							child: const Text('Back to Home'),
						),
					],
				),
			),
		);
	}

	@override
	void recieve(Map<String, dynamic>? data) {
		print("Received data from AuthController: $data");
	}
}
