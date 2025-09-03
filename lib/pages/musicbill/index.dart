import 'package:cicada/states/musicbill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Musicbill extends StatelessWidget {
  const Musicbill({super.key});

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final musicbillList = context.watch<MusicbillState>().musicbillList;
    final musicbill = musicbillList.firstWhere((m) => m.id == argument['id']);
    return Scaffold(
      appBar: AppBar(title: Text(musicbill.name)),
      body: Text("musicbill"),
    );
  }
}
