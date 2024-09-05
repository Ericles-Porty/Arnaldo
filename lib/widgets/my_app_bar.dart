import 'package:flutter/material.dart';

AppBar myAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 32)),
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.primary,
  );
}
