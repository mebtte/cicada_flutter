import 'package:cicada/states/server.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("user management"),
          ElevatedButton(
            onPressed: () {
              serverState.reselectServer();
            },
            child: Text("Change Server"),
          ),
        ],
      ),
    );
  }
}
