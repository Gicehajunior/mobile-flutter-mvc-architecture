import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Repository {
    final BuildContext context;

    const Repository(this.context);

    Future<void> toggleSubmitBtn({required void Function(String label) updateLabel, required String currentBtnText, String temporaryLabel = "Processing...", required Future<void> Function() callbackFunc}) async {
        final original = currentBtnText; 
        updateLabel(temporaryLabel);
        
        // delay executing the callback for 1 second.
        await Future.delayed(Duration(seconds: 1));

        try {
            await callbackFunc();
        } finally {
            updateLabel(original);
        }
    }

    Future<void> alert({required String status, required String title, required String message, String buttonText = 'Ok'}) async {
        final dialog = showDialog(
            context: context,
            builder: (ctx) {
                return AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: [
                        // add a button
                        TextButton(
                            child: Text(buttonText),
                            onPressed: () {
                                context.pop();
                            }
                        ),
                    ]
                );
            }
        );

        return dialog;
    }
}