import 'package:cicada/server_management/index.dart';
import 'package:cicada/user_management/index.dart';
import 'package:cicada/states/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hello World!')));
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final serverState = context.watch<ServerState>();
    return MaterialApp(
      home: serverState.currentServer == null
          ? ServerManagement()
          : serverState.currentUser == null
          ? UserManagement()
          : AppContent(),
    );
  }
}
