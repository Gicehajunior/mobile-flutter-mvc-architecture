import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvcflutter/config/app_config.dart';
import 'package:mvcflutter/public/repos/lang/en.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/session_manager.dart';
import 'package:mvcflutter/config/provider_registry.dart';
// import 'package:mvcflutter/public/repos/methods/global.dart';

class Repository {

  final WidgetRef ref;

  final BuildContext context;

  final ProviderRegistry registry;

  const Repository(this.context, this.ref, this.registry);

  String public(String key, [String relativePath = '']) {
    final basePaths = configList['BasePaths'] as Map<String, String>?;

    if (basePaths == null || !basePaths.containsKey(key)) {
      throw Exception('Invalid asset key: $key');
    }

    return basePaths[key]! + relativePath;
  }

  Widget applicationLogo(
      {String key = 'logos',
      String value = 'svg/default-logo.svg',
      double height = 100,
      double width = 100}) {
    return Center(
      child: SvgPicture.asset(
        public(key, value),
        width: width,
        height: height,
      ),
    );
  }

  Future<void> toggleSubmitBtn(
      {required void Function(String label) updateLabel,
      required String currentBtnText,
      String temporaryLabel = "Processing...",
      required Future<void> Function() callbackFunc}) async {
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

  Future<void> alert(
      {required String status,
      required String title,
      required String message,
      String buttonText = 'Ok'}) async {
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
                    }),
              ]);
        });

    return dialog;
  }

  Future<void> logout(ProviderRegistry registry) async {
    final sm = SessionManager();

    await sm.clearAll();

    // Check ONLY auth token
    final token = await sm.getSession(key: SessionManager.tokenKey);   

    if (token != null && token.isNotEmpty) {
      alert(
        status: 'error',
        title: 'Logout Denied',
        message: lang['logoutFailed'] ?? 'Logout failed. Please try again.',
      );
      return;
    }

    // clear provider cache
    registry.updateStateProvider(ref, 'session', null); 

    if (!context.mounted) return;
    context.go('/login');
  }
}
