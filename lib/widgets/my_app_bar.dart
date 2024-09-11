import 'package:flutter/material.dart';

AppBar myAppBar({
  required BuildContext context,
  required String title,
  required bool hasLeading,
  List<Widget> actions = const [],
}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 32)),
    titleSpacing: hasLeading ? 0 : NavigationToolbar.kMiddleSpacing,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.primary,
    actions: actions,
  );
}
