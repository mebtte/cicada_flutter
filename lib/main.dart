import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import './app.dart';
import './states/server.dart';
import './audio_handler.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final serverState = ServerState();
  await serverState.initialize();

  var audioHandler = await AudioService.init(builder: () => MyAudioHandler());
  getIt.registerSingleton(audioHandler);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: serverState)],
      child: App(),
    ),
  );
}
