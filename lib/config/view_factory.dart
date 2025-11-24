import 'package:flutter/material.dart';
import 'package:mvcflutter/config/view_interface.dart';
import 'package:mvcflutter/config/view_request.dart';
import 'package:mvcflutter/config/view_list.dart';

class ViewFactory {
    static Widget createView(ViewRequest request) {
        final constructor = viewsList[request.key];

        if (constructor != null) {
            final widget = constructor();

            if (widget is DataReceivable) {
                (widget as DataReceivable).recieve(request.data ?? {});
            }

            return widget;
        }

        return Scaffold(
            body: Center(
                child: Text('View not found for key: "${request.key}"'),
            ),
        );
    }
}
