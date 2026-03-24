import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';  
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
	final Map<String, dynamic>? data;
	// constructor
	const HomeScreen({super.key, this.data});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		return Scaffold(
			appBar: AppBar(title: const Text('Home')),
			body: Center(
				child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
					children: [
						const Text('Welcome Home'),
						const SizedBox(height: 16),
						ElevatedButton(
							onPressed: () => context.push('/login'),
							child: const Text('Go to Login'),
						),
					],
				),
			),
		);
	} 
}
