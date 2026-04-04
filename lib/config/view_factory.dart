import 'package:flutter/material.dart'; 
import 'package:nexus/config/view_request.dart';
import 'package:nexus/config/view_list.dart'; 

class ViewFactory {
  static Widget createView(ViewRequest request) {
    final constructor = viewsList[request.key];

    if (constructor != null) {
      return constructor(request.data);
    }

    return Scaffold(
      body: Center(
        child: Text('View not found for key: "${request.key}"'),
      ),
    );
  }
}
