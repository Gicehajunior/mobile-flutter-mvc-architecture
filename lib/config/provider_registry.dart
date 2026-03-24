import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/config/app_logger.dart';

class ProviderRegistry {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _providers = {};
  final Map<String, dynamic> _simpleProviders = {};
  final Map<String, dynamic> _asyncProviders = {};

  /// Providers that should be invalidated on dispose
  final Set<String> _disposableKeys = {};

  /// Add simple Provider (for dependencies, repositories, etc.)
  Provider<T> addProvider<T>(String key, T Function() create,
      {bool disposable = false}) {
    if (_simpleProviders.containsKey(key)) {
      return _simpleProviders[key]! as Provider<T>;
    }

    final provider = Provider<T>((ref) => create());
    _simpleProviders[key] = provider;

    if (disposable) {
      _disposableKeys.add(key);
    }

    return provider;
  }

  StateProvider<T> addStateProvider<T>(String key, T initialValue,
      {bool disposable = false}) {
    if (_providers.containsKey(key)) {
      return _providers[key]! as StateProvider<T>;
    }

    final provider = StateProvider<T>((ref) => initialValue);
    _providers[key] = provider;

    if (disposable) {
      _disposableKeys.add(key);
    }

    return provider;
  }

  StateProvider<T>? getStateProvider<T>(String key) {
    final provider = _providers[key];
    if (provider == null) return null;
    
    try {
      return provider as StateProvider<T>;
    } catch (e) { 
      return provider as dynamic; 
    }
  }
  
  void updateStateProvider<T>(WidgetRef ref, String key, T value) { 
    // Get the provider without strict type forcing initially
    final provider = _providers[key];

    if (provider == null) { 
      addStateProvider<T>(key, value);
      Log.debug('Provider [$key] created with initial value.');
    } else {  
      ref.read((provider as StateProvider).notifier).state = value;
    }
  }

  TextEditingController getController(String key, {String text = ''}) {
    if (_controllers.containsKey(key)) {
      return _controllers[key]!;
    }

    final controller = TextEditingController(text: text);
    _controllers[key] = controller;
    return controller;
  }

  /// addFutureProvider
  FutureProvider<T> addFutureProvider<T>(
      String key, Future<T> Function(Ref ref) fetchFunction,
      {bool disposable = false}) {
    if (_asyncProviders.containsKey(key)) {
      return _asyncProviders[key]! as FutureProvider<T>;
    }

    final provider = FutureProvider<T>((ref) async {
      return await fetchFunction(ref);
    });

    _asyncProviders[key] = provider;

    if (disposable) {
      _disposableKeys.add(key);
    }

    return provider;
  }

  /// futureProvider getter
  FutureProvider<T>? getFutureProvider<T>(String key) {
    return _providers[key] as FutureProvider<T>?;
  }

  /// Helper method to add focus nodes provider (specific use case)
  Provider<List<FocusNode>> addFocusNodesProvider(String key, int count) {
    return addProvider<List<FocusNode>>(key, () {
      return List.generate(count, (index) => FocusNode());
    });
  }

  /// Helper method to add current focus index provider
  StateProvider<int> addCurrentFocusIndexProvider(String key,
      {int initialValue = 0}) {
    return addStateProvider<int>(key, initialValue);
  }

  void disposeProviders(WidgetRef ref) {
    Log.debug('Disposing disposable providers (invalidate)');

    /// Invalidate disposable state providers
    for (final entry in _providers.entries) {
      final key = entry.key;
      final provider = entry.value;

      if (_disposableKeys.contains(key)) {
        Log.debug('Invalidate Provider [$key]: $provider');
        ref.invalidate(provider);
      }
    }

    /// Invalidate disposable async providers (FutureProvider / StreamProvider)
    for (final entry in _asyncProviders.entries) {
      final key = entry.key;
      final provider = entry.value;

      if (_disposableKeys.contains(key)) {
        Log.debug('Invalidate Async Provider [$key]: $provider');
        ref.invalidate(provider);
      }
    }
  }

  void refreshAllProviders(WidgetRef ref) {
    Log.debug('Refreshing all providers');

    for (final provider in _providers.values) {
      final _ = ref.refresh(provider);
    }

    for (final provider in _asyncProviders.values) {
      final _ = ref.refresh(provider);
    }
  }

  void invalidateProvider(WidgetRef ref, String key) { 
    final provider = _providers[key] ?? _asyncProviders[key] ?? null;
    if (provider != null) { 
      final _ = ref?.refresh(provider);
    }
  }

  void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    clearProviderRegistryResource();
  }

  void clearProviderRegistryResource() {
    _controllers.clear();
  }
}
