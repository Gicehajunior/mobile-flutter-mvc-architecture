import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutterapp/providers/router_provider.dart';
import 'public/index.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}