import 'package:cicada/pages/home/index.dart';
import 'package:cicada/server_management/index.dart';
import 'package:cicada/states/musicbill.dart';
import 'package:cicada/user_management/index.dart';
import 'package:cicada/states/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    musicbillState.reloadMusicbillList(silence: false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: musicbillState)],
      child: MaterialApp(initialRoute: '/', routes: {'/': (context) => Home()}),
    );
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
