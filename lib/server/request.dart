import 'package:cicada/states/server.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class ResponseWrapper {
  final String code;
  final dynamic data;

  ResponseWrapper({required this.code, required this.data});

  factory ResponseWrapper.fromJson(Map<String, dynamic> json) {
    return ResponseWrapper(code: json['code'], data: json['data']);
  }
}

Map<String, String>? getHeader(bool withToken) {
  if (withToken) {
    return {"x-cicada-token": serverState.currentUser?.token ?? ""};
  }
  return null;
}

Future<dynamic> handleResponse(Response<dynamic> response) async {
  if (response.statusCode != 200) {
    throw Exception(
      "The server responsed with code \"${response.statusCode}\"",
    );
  }
  final responseData = ResponseWrapper.fromJson(response.data);
  if (responseData.code != 'success') {
    throw Exception("The server responsed with code \"${responseData.code}\"");
  }
  return responseData.data;
}

Future<dynamic> httpGet<Data>({
  required String path,
  Map<String, String>? query,
  bool withToken = false,
  String? origin,
}) async {
  final response = await dio.get(
    '${origin ?? serverState.currentServer!.origin}$path',
    queryParameters: query,
    options: Options(headers: getHeader(withToken)),
  );
  return handleResponse(response);
}
