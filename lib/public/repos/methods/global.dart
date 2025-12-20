import 'package:flutter/material.dart';

Future<void> wait({int time = 2}) {
  return Future.delayed(Duration(seconds: time));
}

double screenWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width;
}

double screenHeight(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  return height;
}


