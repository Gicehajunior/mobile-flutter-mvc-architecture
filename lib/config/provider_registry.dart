import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProviderRegistry { 
    final Map<String, TextEditingController> _controllers = {};
    final Map<String, dynamic> _providers = {};

    StateProvider<T> addStateProvider<T>(String key, T initialValue) {
        if (_providers.containsKey(key)) {
        return _providers[key]! as StateProvider<T>;
        }

        final provider = StateProvider<T>((ref) => initialValue);
        _providers[key] = provider;
        return provider;
    }
    
    StateProvider<T>? getStateProvider<T>(String key) {
        return _providers[key] as StateProvider<T>?;
    }

    TextEditingController getController(String key, {String text = ''}) {
        if (_controllers.containsKey(key)) {
            return _controllers[key]!;
        }

        final controller = TextEditingController(text: text);
        _controllers[key] = controller;
        return controller;
    }

    void disposeAll() {
        for (final controller in _controllers.values) {
            controller.dispose();
        }

        _controllers.clear();
    }
}
