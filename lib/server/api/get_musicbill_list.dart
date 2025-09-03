import '../request.dart';

class Musicbill {
  final String id;
  final String name;

  Musicbill({required this.id, required this.name});

  factory Musicbill.fromJSON(Map<String, dynamic> json) {
    return Musicbill(id: json['id'], name: json['name']);
  }
}

Future<List<Musicbill>> getMusicbillList() async {
  final responseData = await httpGet(
    path: "/api/musicbill_list",
    withToken: true,
  );
  return (responseData as List<dynamic>)
      .map((json) => Musicbill.fromJSON(json))
      .toList();
}
