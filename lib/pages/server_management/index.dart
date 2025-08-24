import 'dart:collection';

import 'package:cicada/extensions/list.dart';
import 'package:cicada/states/server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

typedef ServerEntry = DropdownMenuEntry<Server>;

class ServerManagement extends StatefulWidget {
  const ServerManagement({super.key});

  @override
  State<ServerManagement> createState() => _ServerManagementState();
}

class _ServerManagementState extends State<ServerManagement> {
  late TextEditingController inputController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverState = context.watch<ServerState>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (serverState.serverList.isNotEmpty)
            DropdownMenu(
              onSelected: (server) =>
                  server == null ? null : serverState.useServer(server.origin),
              label: Text("Existed Servers"),
              dropdownMenuEntries: UnmodifiableListView<ServerEntry>(
                serverState.serverList.map<ServerEntry>(
                  (server) => ServerEntry(
                    label: '${server.hostname}(${server.origin})',
                    value: server,
                  ),
                ),
              ),
            ),
          TextField(
            readOnly: loading,
            controller: inputController,
            decoration: InputDecoration(
              label: Text("Server Origin"),
              hint: Text(
                "https://cicada.example.com",
                style: TextStyle(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    final origin = inputController.text;
                    if (origin.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter server origin")),
                      );
                      return;
                    }

                    if (serverState.serverList.firstWhereOrNull(
                          (server) => server.origin == origin,
                        ) !=
                        null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "This server origin has already existed",
                          ),
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
            style: OutlinedButton.styleFrom(padding: EdgeInsets.all(20)),
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text("Connect"),
          ),
        ],
      ),
    );
  }
}
