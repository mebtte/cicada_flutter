import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text('Server Management'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
