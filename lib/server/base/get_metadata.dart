import 'package:cicada/server/request.dart';
import 'package:cicada/states/server.dart';

class Metadata {
  final String hostname;
  final String version;

  Metadata({required this.hostname, required this.version});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(hostname: json['hostname'], version: json['version']);
  }
}

Future<Metadata> getMetadata(String? origin) async {
  final responseData = await httpGet(
    origin: origin ?? serverState.currentServer!.origin,
    path: "/base/metadata",
  );
  return Metadata.fromJson(responseData);
}
