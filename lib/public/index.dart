import 'package:flutter/material.dart';
import 'package:mvcflutter/config/app_config.dart';
import 'package:mvcflutter/config/app_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/app/providers/router_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: configList['appName'] ?? 'App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }

  Future<void> initializeApp() async {
    try {
      await dotenv.load();
    } catch (error) {
      Log.debug(error);
    }
  }
}
