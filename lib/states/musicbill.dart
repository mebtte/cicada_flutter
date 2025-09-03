import '../server/api/get_musicbill_list.dart';
import 'package:flutter/material.dart';

class Musicbill {
  String id;
  String name;

  Musicbill({required this.id, required this.name});
}

class MusicbillState extends ChangeNotifier {
  bool loading = false;
  Exception? exception;
  List<Musicbill> musicbillList = [];

  void reloadMusicbillList({required bool silence}) async {
    exception = null;
    loading = true;
    notifyListeners();

    try {
      final data = await getMusicbillList();
      musicbillList = data
          .map((m) => Musicbill(id: m.id, name: m.name))
          .toList();
    } catch (e) {
      exception = e as Exception;
    }
    loading = false;
    notifyListeners();
  }
}

final musicbillState = MusicbillState();
