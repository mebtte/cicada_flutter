import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './app.dart';
import './states/server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final serverState = ServerState();
  await serverState.initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: serverState)],
      child: App(),
    ),
  );
}
