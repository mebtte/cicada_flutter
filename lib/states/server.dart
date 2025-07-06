import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage.dart';
import 'dart:convert';

class User {
  String token;
  String? avatar;
  int createMusicMaxAmount;
  String id;
  bool twoFAEnabled;
  String username;
  String nickname;

  User({
    required this.token,
    required this.avatar,
    required this.createMusicMaxAmount,
    required this.id,
    required this.twoFAEnabled,
    required this.username,
    required this.nickname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json['token'],
    avatar: json['avatar'],
    createMusicMaxAmount: json['createMusicMaxAmount'],
    id: json['id'],
    twoFAEnabled: json['twoFAEnabled'],
    username: json['username'],
    nickname: json['nickname'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'avatar': avatar,
    'createMusicMaxAmount': createMusicMaxAmount,
    'id': id,
    'twoFAEnabled': twoFAEnabled,
    'username': username,
    'nickname': nickname,
  };
}

class Server {
  String origin;
  String hostname;
  String version;

  Server({required this.origin, required this.hostname, required this.version});

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    origin: json['origin'],
    hostname: json['hostname'],
    version: json['version'],
  );

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
    notifyListeners();
  }
}
