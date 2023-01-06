import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:resources_mover/logic/mover_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {'/mover': (context) => const MoverView()},
    initialRoute: '/mover',
    builder: BotToastInit(), //1. call BotToastInit
    navigatorObservers: [BotToastNavigatorObserver()],
  ));
}
