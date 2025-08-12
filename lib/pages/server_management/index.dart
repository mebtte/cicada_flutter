import 'package:cicada/audio_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PageServerManagement extends StatelessWidget {
  const PageServerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Server Management')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var audioHandler = GetIt.instance<MyAudioHandler>();
            // var item = MediaItem(
            //   id: 'https://music.mebtte.com/asset/music/c35d5d229458cd5266e366e4a5bee717.m4a',
            //   album: 'Album name',
            //   title: 'Track title',
            //   artist: 'Artist name',
            //   duration: const Duration(milliseconds: 123456),
            //   artUri: Uri.parse(
            //     'https://music.mebtte.com/asset/music_cover/8de82c491047b3bddbd88f8b21408e72.jpg',
            //   ),
            // );
            // await audioHandler.playMediaItem(item);
            // await audioHandler.play();
            audioHandler.playTest();
          },
          child: Text("play123"),
        ),
      ),
    );
  }
}
