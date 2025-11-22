import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/view_interface.dart';
import 'package:mvcflutter/app/providers/registry_provider.dart';

class LoginScreen extends ConsumerWidget with DataReceivable {
	final String? email;
	final String? password;

	const LoginScreen({super.key, this.email, this.password});

	@override
	Widget build(BuildContext context, WidgetRef ref) { 
		final registry = ref.watch(controllerRegistryProvider);

		final emailController = registry.getController('email', text: email ?? '');
		final passwordController = registry.getController('password', text: password ?? '');

		return Scaffold(
			appBar: AppBar(title: const Text('Login'), centerTitle: true),
			body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 24.0),
				child: Center(
					child: SingleChildScrollView(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								// Logo or App title placeholder
								const FlutterLogo(size: 100),
								const SizedBox(height: 32),

								// Email field
								TextField(
									controller: emailController,
									keyboardType: TextInputType.emailAddress,
									decoration: const InputDecoration(
										labelText: 'Email',
										border: OutlineInputBorder(),
										prefixIcon: Icon(Icons.email),
									),
								),

								const SizedBox(height: 16),

								// Password field
								TextField(
									controller: passwordController,
									obscureText: true,
									decoration: const InputDecoration(
										labelText: 'Password',
										border: OutlineInputBorder(),
										prefixIcon: Icon(Icons.lock),
									),
								),

								const SizedBox(height: 24),

								// Forgot password Text
								SizedBox(
									width: double.infinity,
									child: RichText(
										textAlign: TextAlign.right,
										text: TextSpan(
											text: 'Forgot Password? Click ',
											style: TextStyle(
												color: Colors.black,
												fontSize: 12
											),
											children: [
												TextSpan(
													text: 'here',
													style: TextStyle(
														color: Colors.blue,
														fontSize: 12,
														fontWeight: FontWeight.bold
													),
													recognizer: TapGestureRecognizer()
																	..onTap = () {
																		context.go('/forgot-password');
																	}
												)
											]
										)
									)
								),

								const SizedBox(height: 24),

								// Login button
								SizedBox(
									width: double.infinity, 
									child: ElevatedButton(
										onPressed: () { 
											context.go('/');
										},
										child: const Text('Login'),
									),
								),
								
								const SizedBox(height: 16),

								// Optional prefilled email display
								if (email != null)
								Text(
									'Prefilled email: $email',
									style: TextStyle(color: Colors.grey[700]),
								),
							],
						),
					),
				),
			),
		);
	}

	@override
	void recieve(Map<String, dynamic>? data) {
		print("Received data from AuthController: $data");
	}
}
