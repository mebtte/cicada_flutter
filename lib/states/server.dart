import 'package:cicada/extensions/list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage.dart';
import 'dart:convert';

class User {
  String token;
  String? avatar;
  String id;
  bool twoFAEnabled;
  String username;
  String nickname;

  User({
    required this.token,
    required this.avatar,
    required this.id,
    required this.twoFAEnabled,
    required this.username,
    required this.nickname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json['token'],
    avatar: json['avatar'],
    id: json['id'],
    twoFAEnabled: json['twoFAEnabled'],
    username: json['username'],
    nickname: json['nickname'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'avatar': avatar,
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
  List<User> users;

  Server({
    required this.origin,
    required this.hostname,
    required this.version,
    required this.users,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    origin: json['origin'],
    hostname: json['hostname'],
    version: json['version'],
    users: (json['users'] as List<dynamic>)
        .map((json) => User.fromJson(json))
        .toList(),
  );

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'hostname': hostname,
      'version': version,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

class ServerState extends ChangeNotifier {
  List<Server> serverList = [];
  String? selectedServerOrigin;
  String? selectedUserId;

  Server? get currentServer => serverList.firstWhereOrNull(
    (server) => server.origin == selectedServerOrigin,
  );

  User? get currentUser => currentServer?.users.firstWhereOrNull(
    (user) => user.id == selectedUserId,
  );

  Map<String, dynamic> toJson() {
    return {
      'selectedServerOrigin': selectedServerOrigin,
      'selectedUserId': selectedUserId,
      'serverList': jsonEncode(serverList),
    };
  }

  Future<void> initialize() async {
    final preference = await SharedPreferences.getInstance();
    final serverString = preference.getString(StorageKey.SERVER);
    if (serverString != null) {
      final Map<String, dynamic> server = jsonDecode(serverString);
      final undecodedServerList =
          jsonDecode(server['serverList']) as List<dynamic>;
      final serverList = undecodedServerList
          .map((json) => Server.fromJson(json))
          .toList();
      this.serverList = serverList;
      selectedServerOrigin = server['selectedServerOrigin'];
      selectedUserId = server['selectedUserId'];
    }
    notifyListeners();
  }

  void addServer(Server server) {
    serverList.add(server);
    selectedServerOrigin = server.origin;
    notifyListeners();
  }

  void useServer(String origin) {
    selectedServerOrigin = origin;
    notifyListeners();
  }

  void reselectServer() {
    selectedUserId = null;
    selectedServerOrigin = null;
    notifyListeners();
  }

  void clearServers() {
    selectedUserId = null;
    selectedServerOrigin = null;
    serverList = [];
    notifyListeners();
  }

  void addUser(User user) {
    currentServer?.users.add(user);
    selectedUserId = user.id;
    notifyListeners();
  }

  void useUser(String id) {
    selectedUserId = id;
    notifyListeners();
  }

  void reselectUser() {
    selectedUserId = null;
    notifyListeners();
  }

  void saveOnChange() {
    addListener(() async {
      final preference = await SharedPreferences.getInstance();
      preference.setString(StorageKey.SERVER, jsonEncode(this));
    });
  }
}

final serverState = ServerState();
