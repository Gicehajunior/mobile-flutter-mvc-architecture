import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControllerRegistry { 
    final Map<String, TextEditingController> _controllers = {};

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
