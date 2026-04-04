import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/app/providers/registry_provider.dart';
import 'package:mvcflutter/public/repos/mobile/auth_repository.dart';

class ForgotPassword extends ConsumerWidget {
  final Map<String, dynamic>? data;

  const ForgotPassword({super.key, this.data});

  /// Build the UI skin.
  /// This build function ensures the Forgot password UI is drawn and applicable fields
  /// are crafted inside the UI container.
  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final registry = ref.watch(providersRegistry);
		AuthRepository auth = AuthRepository(context, ref, registry);

    final emailController = registry.getController('email', text: data?['email'] ?? '');
    final resetPasswordBtnProvider =
        registry.addStateProvider<String>('resetPasswordBtn', 'Reset Password');
    final resetPasswordBtnText = ref.watch(resetPasswordBtnProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Forgot Password'), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  // Logo section
                  const FlutterLogo(size: 100),

                  // apply some gaps
                  SizedBox(height: 32),

                  // Add an email text field
                  TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email))),

                  // apply some gaps
                  SizedBox(height: 40),

                  //Add a submit button, for a forgot password request
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: Text(resetPasswordBtnText),
                          onPressed: () async { 
                            await auth.toggleSubmitBtn(
                              updateLabel: (label, loading) {
                                ref
                                    .read(resetPasswordBtnProvider.notifier)
                                    .state = label;
                              },
                              currentBtnText:
                                  ref.watch(resetPasswordBtnProvider),
                              temporaryLabel: "Sending...",
                              callbackFunc: () async {
                                await auth.resetPassword(
                                  email: emailController.text.trim(),
                                );
                              },
                            );
                          }))
                ])))));
  }
}
