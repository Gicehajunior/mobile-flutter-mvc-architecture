import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/provider_registry.dart';

final providersRegistry = Provider.autoDispose<ProviderRegistry>((ref) {
    final registry = ProviderRegistry();
    ref.onDispose(registry.disposeAll);
    return registry;
});

