import 'package:flutter/material.dart';

class PlayqueueMusic {
  final String id;
  final String name;
  final String asset;

  PlayqueueMusic({required this.id, required this.name, required this.asset});
}

class PlayqueueState extends ChangeNotifier {
  int playqueueIndex = -1;
  List<PlayqueueMusic> playqueue = [];

  PlayqueueMusic? get currentMusic => playqueue[playqueueIndex];

  void insert(PlayqueueMusic music) {
    if (playqueueIndex == -1) {
      playqueue = [music, ...playqueue];
    } else {
      playqueue = [
        ...playqueue.sublist(0, playqueueIndex),
        music,
        ...playqueue.sublist(playqueueIndex),
      ];
    }
    notifyListeners();
  }
}

final playqueueState = PlayqueueState();
