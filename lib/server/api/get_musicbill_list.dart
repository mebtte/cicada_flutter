import 'package:cicada/server/request.dart';

class Musicbill {
  final String id;

  Musicbill({required this.id});

  factory Musicbill.fromJSON(Map<String, dynamic> json) {
    return Musicbill(id: json['id']);
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
