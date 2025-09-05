import 'dart:math';

import 'package:cicada/states/playqueue.dart';
import 'package:flutter/material.dart';

final random = Random();

class PlaylistMusic {
  final String pid;
  final String id;
  final String name;
  final String asset;

  PlaylistMusic({
    required this.pid,
    required this.id,
    required this.name,
    required this.asset,
  });
}

class PlaylistState extends ChangeNotifier {
  List<PlaylistMusic> playlist = [];

  void addMusicList(List<PlaylistMusic> musicList) {
    final existedMusicIds = playlist.map((m) => m.id).toList();
    final unrepeatedMusicList = musicList
        .where((m) => !existedMusicIds.contains(m.id))
        .toList();
    playlist.addAll(unrepeatedMusicList);
    notifyListeners();

    Future.delayed(Duration.zero, () {
      if (playqueueState.currentMusic == null) {
        final music = playlist[random.nextInt(playlist.length)];
        playqueueState.insert(
          PlayqueueMusic(id: music.id, name: music.name, asset: music.asset),
        );
      }
    });
  }
}

final playlistState = PlaylistState();
