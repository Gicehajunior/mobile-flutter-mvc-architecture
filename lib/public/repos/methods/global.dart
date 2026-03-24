import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/app_logger.dart'; 
import 'package:mvcflutter/config/provider_registry.dart';
import 'package:mvcflutter/config/session_manager.dart'; 

Future<void> wait({int time = 2}) {
  return Future.delayed(Duration(seconds: time));
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

String capitalizeFirst(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

String capitalizeWords(String text) {
  return text
      .split(' ')
      .map((word) =>
          word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}