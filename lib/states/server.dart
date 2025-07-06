import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage.dart';
import 'dart:convert';

class Server {
  final String origin;

  Server({required this.origin});

  factory Server.fromJson(Map<String, dynamic> json) =>
      Server(origin: json['origin']);

  Map<String, dynamic> toJson() {
    return {'origin': origin};
  }
}

class ServerState extends ChangeNotifier {
  List<Server> serverList = [];
  String? selectedServerOrigin;

  Server? get currentServer => selectedServerOrigin == null
      ? null
      : serverList.firstWhere(
          (server) => server.origin == selectedServerOrigin,
        );

  Future<void> initialize() async {
    final preference = await SharedPreferences.getInstance();
    final serverListString = preference.getString(StorageKey.SERVER_LIST);
    final selectedServerOrigin = preference.getString(
      StorageKey.SELECTED_SERVER_ORIGIN,
    );
    if (serverListString != null) {
      final List<Server> serverList =
          (jsonDecode(serverListString) as List<Map<String, dynamic>>)
              .map((json) => Server.fromJson(json))
              .toList();
      this.serverList = serverList;
      this.selectedServerOrigin = selectedServerOrigin;
    }
  }
}
