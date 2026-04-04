import 'dart:io';
import 'dart:convert'; 
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus/config/app_logger.dart'; 
import 'package:nexus/config/session_manager.dart'; 
import 'package:nexus/config/provider_registry.dart'; 

/// Parses and returns the 
/// type/version of the running 
/// device
String getCurrentPlatform() {
  if (kIsWeb) {
    return 'web';
  }

  if (Platform.isAndroid) {
    return 'android';
  }

  if (Platform.isIOS) {
    return 'ios';
  }

  if (Platform.isWindows) {
    return 'windows';
  }

  if (Platform.isMacOS) {
    return 'macos';
  }

  if (Platform.isLinux) {
    return 'linux';
  }

  return 'unknown';
}

/// Pretty prints JSON data with indentation
String prettyJson(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(data);
}

Future<void> wait({int time = 2, String type = 'seconds'}) async {
  Duration duration;

  switch (type.toLowerCase()) {
    case 'minutes':
      duration = Duration(minutes: time);
      break;
    case 'milliseconds':
      duration = Duration(milliseconds: time);
      break;
    case 'seconds':
    default:
      duration = Duration(seconds: time);
  }

  return await Future.delayed(duration);
}

double screenWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width;
}

double screenHeight(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  return height;
}

Future<Map<String, dynamic>> session() async {
  SessionManager sm = SessionManager();
  final sessionObj = await sm.getSession();

  // Ensure it's a Map, fallback to empty
  final Map<String, dynamic> session = sessionObj ?? {};

  return session;
}

bool checkPermission(dynamic permissions, String permissionKey) {
  try {
    dynamic perms = permissions ?? [];

    // convert perms toList if it's not already
    if (perms is! List) {
      perms = perms.split(',');
      perms = perms.map((perm) => perm.trim()).toList();
    }

    return perms.contains(permissionKey);
  } catch (e) {
    return false;
  }
}

void providerRefreshBulkUtil(WidgetRef ref,
    {required List<FutureProvider<Object>> providers}) {
  for (var provider in providers) {
    final _ = ref.refresh(provider);
  }
}

String formatDate(String dateString, {bool isMobile = false}) {
  try {
    final date = DateTime.parse(dateString);
    if (isMobile) {
      // Short format for mobile
      return '${date.day}/${date.month}/${date.year}';
    } else {
      // Longer format for desktop
      return DateFormat('MMM dd, yyyy').format(date);
    }
  } catch (e) {
    return dateString;
  }
}

/// Start timer upon UI build
void setTimeInterval(
  ProviderRegistry registry, {
  required WidgetRef ref,
  required String key,
}) {
  final timerProvider = registry.getStateProvider(key);
  if (timerProvider == null) return;
  
  // if (ref.read(timerProvider) != 60) return;

  void tick() { 
    try {
      final value = ref.read(timerProvider);

      if (value <= 0) return;

      ref.read(timerProvider.notifier).state = value - 1;
      
      Log.debug("Provider log: $key ${ref.read(timerProvider)}");
      Future.delayed(const Duration(seconds: 1), tick);
    } catch (_) { 
      return;
    }
  }

  // Kick off after build completes
  Future.microtask(tick);
}

String getInitials(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  return parts.length > 1 
    ? '${parts[0][0]}${parts[1][0]}'.toUpperCase() 
    : parts[0][0].toUpperCase();
}
