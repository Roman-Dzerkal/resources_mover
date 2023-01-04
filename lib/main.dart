import 'package:flutter/material.dart';
import 'package:resources_mover/logic/mover_view.dart';

void main() {
  runApp(MaterialApp(
    routes: {'/mover': (context) => const MoverView()},
    initialRoute: '/mover',
  ));
}
