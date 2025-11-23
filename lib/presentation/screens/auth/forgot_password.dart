import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/view_interface.dart';
import 'package:mvcflutter/app/providers/registry_provider.dart';
import 'package:mvcflutter/public/repos/mobile/auth_repository.dart';

class ForgotPassword extends ConsumerWidget with DataReceivable {
    final String? email;

    const ForgotPassword({super.key, this.email});
 
    /**
     * Well, recieve data from the backend, incase of need for prefill, 
     * return the data to the UI.
     */
    @override
    void recieve(Map<String, dynamic>? data ) {
        print("Received data from AuthController: $data");
    }

    /**
     * Build the UI skin. 
     * This build function ensures the Forgot password UI is drawn and applicable fields
     * are crafted inside the UI container.
     */
    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // as usual, watch the controller registry provider
        final registry = ref.watch(controllerRegistryProvider);
        final emailController = registry.getController('email', text: email ?? '');

        return Scaffold(
            appBar: AppBar(
                title: const Text('Forgot Password'),
                centerTitle: true
            ),
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
                                SizedBox(
                                    height: 32
                                ),

                                // Add an email text field
                                TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.email)
                                    )
                                ),

                                // apply some gaps
                                SizedBox(
                                    height: 40
                                ),

                                //Add a submit button, for a forgot password request
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        child: const Text('Forgot Password'),
                                        onPressed: () {
                                            //...
                                        }
                                    )
                                )
                            ]
                        )
                    )
                )
            )
        );
    }
}