import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/controller_registry.dart';

final controllerRegistryProvider = Provider.autoDispose<ControllerRegistry>((ref) {
    final registry = ControllerRegistry();
    ref.onDispose(registry.disposeAll);
    return registry;
});

