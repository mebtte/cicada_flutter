import 'package:cicada/pages/server_management/appbar.dart';
import 'package:flutter/material.dart';

class PageServerManagement extends StatelessWidget {
  const PageServerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: Center(child: Text('server')),
    );
  }
}
