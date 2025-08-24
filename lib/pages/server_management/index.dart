import 'package:cicada/states/server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final double MAX_WIDTH = 600;
final _dio = Dio();

class Metadata {
  final String hostname;
  final String version;

  Metadata({required this.hostname, required this.version});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(hostname: json['hostname'], version: json['version']);
  }
}

class MetadataResponse {
  final String code;
  final Metadata data;

  MetadataResponse({required this.code, required this.data});

  factory MetadataResponse.fromJson(Map<String, dynamic> json) {
    return MetadataResponse(
      code: json['code'],
      data: Metadata.fromJson(json['data']),
    );
  }
}

class ServerManagement extends StatefulWidget {
  const ServerManagement({super.key});

  @override
  State<ServerManagement> createState() => _ServerManagementState();
}

class _ServerManagementState extends State<ServerManagement> {
  late TextEditingController controller;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Server Management')),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: MAX_WIDTH),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  readOnly: loading,
                  controller: controller,
                  decoration: InputDecoration(
                    label: Text("Server Origin"),
                    hint: Text(
                      "https://cicada.example.com",
                      style: TextStyle(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: loading
                        ? null
                        : () async {
                            final origin = controller.text;
                            if (origin.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please enter server origin"),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              loading = true;
                            });
                            try {
                              final response = await _dio.get(
                                "$origin/base/metadata?__lang=en",
                              );
                              if (response.statusCode != 200) {
                                throw Exception(
                                  "The origin responsed with code \"${response.statusCode}\"",
                                );
                              }
                              final responseData = MetadataResponse.fromJson(
                                response.data,
                              );
                              if (responseData.code != "success") {
                                throw Exception(
                                  "The origin responsed with code \"${responseData.code}\"",
                                );
                              }
                              serverState.addServer(
                                Server(
                                  origin: origin,
                                  hostname: responseData.data.hostname,
                                  version: responseData.data.version,
                                  users: <User>[],
                                ),
                              );
                            } catch (exception) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Failed to connect to \"$origin\" with exception \"${exception.toString()}\"",
                                  ),
                                ),
                              );
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                    icon: loading ? null : Icon(Icons.forward),
                    label: loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Text("Connect"),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
