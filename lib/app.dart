import 'package:cicada/pages/server_management/index.dart';
import 'package:cicada/pages/user_management/index.dart';
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
    final currentServer = context.watch<ServerState>().currentServer;
    final currentUser = currentServer?.users.firstWhere(
      (user) => user.id == currentServer.selectedUserId,
    );
    return MaterialApp(
      home: currentServer == null
          ? ServerManagement()
          : currentUser == null
          ? UserManagement()
          : AppContent(),
    );
  }
}
