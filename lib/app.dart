import 'package:cicada/pages/server_management/index.dart';
import 'package:cicada/states/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final currentServer = context.watch<ServerState>().currentServer;
    return MaterialApp(
      home: currentServer == null
          ? PageServerManagement()
          : Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
