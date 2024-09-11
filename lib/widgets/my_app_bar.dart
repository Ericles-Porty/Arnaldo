import 'package:flutter/material.dart';

AppBar myAppBar({
  required BuildContext context,
  required String title,
  List<Widget> actions = const [],
}) {
  bool hasLeading = ModalRoute.of(context)?.canPop ?? false;

  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 32)),
    titleSpacing: hasLeading ? 0 : NavigationToolbar.kMiddleSpacing,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.primary,
    actions: actions,
  );
}
