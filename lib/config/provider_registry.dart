import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexus/config/app_logger.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

class ProviderRegistry {
  final Map<String, dynamic> _providers = {};
  final Map<String, dynamic> _simpleProviders = {};
  final Map<String, dynamic> _asyncProviders = {};

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, ScrollController> _scrollControllers = {};

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
  
  Provider<T>? getProvider<T>(String key) {
    return _simpleProviders[key] as Provider<T>?;
  }

  dynamic addStateProvider<T>(
    String key,
    T initialValue, {
    bool disposable = false,
  }) {
    final existing = _providers[key];

    if (existing != null) {
      return existing; // Return as is
    }

    // Logic for autoDispose vs Standard
    final provider = disposable
        ? StateProvider.autoDispose<T>((ref) => initialValue)
        : StateProvider<T>((ref) => initialValue);

    _providers[key] = provider;

    if (disposable) {
      _disposableKeys.add(key);
    }

    return provider;
  }

  StateProvider<T>? getStateProvider<T>(String key) {
    final provider = _providers[key];

    if (provider is StateProvider<T>) {
      return provider;
    }

    return null;
  }
    
  void updateStateProvider<T>(
    WidgetRef ref, 
    String key, 
    T value, {
    bool disposable = false,
  }) { 
    // Fetch or Create: Logic to ensure the provider exists in your tracking map
    final provider = _providers[key] ?? addStateProvider<T>(key, value, disposable: disposable);
    
    // on StateProvider vs AutoDisposeStateProvider.
    final notifier = ref.read((provider as dynamic).notifier);
    
    // Ensure we are actually updating the state
    notifier.state = value;
  }

  TextEditingController getController(String key, {String text = ''}) {
    if (_controllers.containsKey(key)) {
      return _controllers[key]!;
    }

    final controller = TextEditingController(text: text);
    _controllers[key] = controller;
    return controller;
  }

  SearchController getSearchController(String key, {String? text, bool disposable = false}) {
    if (!_controllers.containsKey(key)) {
      final controller = SearchController()..text = text ?? '';
      _controllers[key] = controller;
      
      if (disposable) {
        _disposableKeys.add(key);
      }
    }
    return _controllers[key] as SearchController;
  }

  void updateControllerText(String key, String newText) {
    final controller = _controllers[key];
    if (controller is TextEditingController) { 
      if (controller.text != newText) {
        controller.text = newText;
        Log.debug('Updated controller [$key] text to: $newText');
      }
    }
  }

  ScrollController? getScrollController(String key) {
    return _scrollControllers[key];
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

  void invalidateAllProviders(WidgetRef ref) {
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

  void refreshBulkProviders(WidgetRef ref, providers) {
    Log.debug('Bulk Refreshing Given providers!');

    for (final provider in providers) { 
      if (_providers.containsKey(provider)) {
        final _ = ref.refresh(provider);
      }
    }

    for (final provider in providers) { 
      if (_asyncProviders.containsKey(provider)) {
        final _ = ref.refresh(provider);
      }
    } 
  }
    
  void invalidateBulkProviders(WidgetRef ref, List<String> keys) {
    Log.debug('Bulk Invalidating providers for keys: $keys');

    for (final key in keys) {  
      final provider = _providers[key] ?? _asyncProviders[key];

      if (provider != null) { 
        ref.invalidate(provider);
        ref.watch(provider);
      } else {
        Log.debug('Provider key "$key" not found in registry!');
      }
    }
  }

  ScrollController getOrCreateScrollController(String key, ScrollController Function() onFirstCreate) {
    if (_scrollControllers.containsKey(key)) {
      return _scrollControllers[key]!;
    }

    final controller = onFirstCreate();
    _scrollControllers[key] = controller;
    return controller;
  }

  void clearDisposables(WidgetRef ref) {
    for (var key in _disposableKeys) {
      // Handle State Providers (Riverpod)
      final provider = _providers[key] ?? _asyncProviders[key];
      if (provider != null) {
        ref.invalidate(provider);
        _providers.remove(key);
        _asyncProviders.remove(key);
      }

      // Handle Controllers (Flutter Lifecycle)
      final controller = _controllers[key]; 
      if (controller is Listenable) {  
        (controller as dynamic).dispose(); 
      }

      _controllers.remove(key); 
      
      Log.debug('Manually cleared: $key');
    }
    _disposableKeys.clear();
  }

  void disposeAll() {
    for (final controller in _controllers.values) { 
      controller.dispose();
    }

    for (final controller in _scrollControllers.values) {
      Log.debug("DIESPOSING OFF SCROLL CONTROLLER: $controller");
      controller.dispose();
    }

    clearProviderRegistryResource();
  }

  void clearProviderRegistryResource() {
    _controllers.clear();
    _scrollControllers.clear();
  }

  void invalidateProvider(WidgetRef ref, String key) { 
    final provider = _providers[key] ?? _asyncProviders[key];
    if (provider != null) {
      Log.debug("INVALIDATING SESSION PROVIDER: $provider");
      final _ = ref.refresh(provider);
    }
  }
}
