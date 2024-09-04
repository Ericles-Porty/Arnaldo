import 'dart:io';

import 'package:arnaldo/app_module.dart';
import 'package:arnaldo/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> resetDatabase() async {
  String path = join(await getDatabasesPath(), 'arnaldo.db');
  print(path);
  await deleteDatabase(path);
}

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();
  //await resetDatabase();

  setPrintResolver((text) => print(text));

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
