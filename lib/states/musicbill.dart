import 'package:cicada/server/api/get_musicbill_list.dart';
import 'package:flutter/material.dart';

class Musicbill {
  String id;

  Musicbill({required this.id});
}

class _MusicbillState extends ChangeNotifier {
  bool loading = false;
  Exception? exception;
  List<Musicbill> musicbillList = [];

  void reloadMusicbillList({required bool silence}) async {
    exception = null;
    loading = true;
    notifyListeners();

    try {
      final data = await getMusicbillList();
      musicbillList = data.map((m) => Musicbill(id: m.id)).toList();
    } catch (e) {
      exception = e as Exception;
    }
    loading = false;
    notifyListeners();
  }
}

final musicbillState = _MusicbillState();
