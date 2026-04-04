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

  Future<void> toggleSubmitBtn({
    required Future<void> Function(String label, bool loading) updateLabel,
    required String currentBtnText,
    String temporaryLabel = "Processing...",
    required Future<void> Function() callbackFunc
  }) async {
    final original = currentBtnText;

    await updateLabel(temporaryLabel, true); 
    await WidgetsBinding.instance.endOfFrame;

    try { 
      await callbackFunc();
    } finally {
      updateLabel(original, false);
    }
  }
  
  Future<void> alert({
    required String status,
    required String title,
    required String message,
    String buttonText = 'Ok',
    bool showBtn = true,
    bool isLoading = false,
    VoidCallback? onConfirm,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 20),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
            ],
          ),
          actions: [
            if (showBtn)
              Center(
                child: TextButton(
                  child: Text(buttonText),
                  onPressed: () {
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                ),
              ),
          ]);
      });
  }

  Future<void> logout() async { 
    final sm = SessionManager();
    await sm.clearAll(); // Wait until the physical files are deleted
    
    registry.addStateProvider<bool>('isLoggingOutProvider', false);
    await wait(time: 500, type: 'milliseconds');

    final sessionProvider = registry.getStateProvider('sessionProvider');
    if (sessionProvider != null) {
      ref.invalidate(sessionProvider); 
    }

    registry.updateStateProvider(ref, 'session', Map<String, dynamic>.from({})); 
    registry.invalidateAllProviders(ref);
    
    alert(
      showBtn: false,
      isLoading: true,
      status: 'info', 
      title: 'Logging Out', 
      message: 'Please wait as we try logging you out!',
    );
          
    await wait(time: 3, type: 'seconds');

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

    if (!context.mounted) return;

    registry.updateStateProvider<bool>(ref, 'isLoggingOutProvider', true); 
    await wait(time: 300, type: 'milliseconds');

    context.go('/login');
  }
}
