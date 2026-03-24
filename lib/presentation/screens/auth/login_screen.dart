import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:mvcflutter/app/providers/registry_provider.dart'; 
import 'package:mvcflutter/public/repos/mobile/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
	final Map<String, dynamic>? data; 
	
	const LoginScreen({super.key, this.data});

	@override
	Widget build(BuildContext context, WidgetRef ref) { 
		final registry = ref.watch(providersRegistry);
		AuthRepository auth = AuthRepository(context, ref, registry);

		final emailController = registry.getController('email', text: data?['email'] ?? '');
		final passwordController = registry.getController('password', text: data?['password'] ?? ''); 
		final loginBtnProvider = registry.addStateProvider<String>('loginBtn', 'Login');
		final loginBtnText = ref.watch(loginBtnProvider);

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
									child: Row(
										mainAxisAlignment: MainAxisAlignment.end,
										children: [
											Text(
												'Forgot Password? Click ',
												style: TextStyle(
													color: Colors.black,
													fontWeight: FontWeight.bold,
													fontSize: 12
												),
											), 
											GestureDetector(
												child: Text('here',
													style: TextStyle(
														color: Colors.blue,
														fontWeight: FontWeight.bold,
														fontSize: 12
													),
												),
												onTap: () {
													context.push('/forgot-password');
												}
											)
										]
									)
								),

								const SizedBox(height: 24),

								// Login button
								SizedBox(
									width: double.infinity, 
									child: ElevatedButton(
										onPressed: () async {  
											await auth.toggleSubmitBtn(
												updateLabel: (label) {
													ref.read(loginBtnProvider.notifier).state = label;
												},
												currentBtnText: loginBtnText,
												temporaryLabel: "Logging in...",
												callbackFunc: () async {    
													await auth.authLogin(
														email: emailController.text.trim(),
														password: passwordController.text.trim(),
													);
												},
											);
										},
										child: Text(loginBtnText),
									),
								),
								
								const SizedBox(height: 16),

								// Optional prefilled email display
								if (data?['email'] != null)
								Text(
									'Prefilled email: ${data?['email']}',
									style: TextStyle(color: Colors.grey[700]),
								),
							],
						),
					),
				),
			),
		);
	} 
}
