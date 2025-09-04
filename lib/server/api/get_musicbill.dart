import '../request.dart';

class Music {
  String id;
  String name;
  String asset;

  Music({required this.id, required this.name, required this.asset});

  factory Music.fromJSON(Map<String, dynamic> json) {
    return Music(id: json['id'], name: json['name'], asset: json['asset']);
  }
}

class Musicbill {
  String name;
  List<Music> musicList;

  Musicbill({required this.name, required this.musicList});

  factory Musicbill.fromJSON(Map<String, dynamic> json) {
    return Musicbill(
      name: json['name'],
      musicList: (json['musicList'] as List<dynamic>)
          .map((json) => Music.fromJSON(json))
          .toList(),
    );
  }
}

Future<Musicbill> getMusicbill({required String id}) async {
  final responseData = await httpGet(
    path: "/api/musicbill",
    query: {"id": id},
    withToken: true,
  );
  return Musicbill.fromJSON(responseData);
}
