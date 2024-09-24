import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportarPage extends StatelessWidget {
  Future<bool> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      // Solicita permissão se ainda não foi concedida
      var result = await Permission.manageExternalStorage.request();

      if (result.isGranted) {
        print('Permissão de armazenamento concedida.');
      } else if (result.isDenied) {
        print('Permissão de armazenamento negada.');
      } else if (result.isPermanentlyDenied) {
        print('Permissão negada permanentemente. Vá para as configurações para conceder.');
        openAppSettings();
      }
      return result.isGranted;
    }
    print('Permissão já concedida.');
    return true;
  }

  const ExportarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Modular.get<DatabaseHelper>();
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Exportar', hasLeading: true),
      body: Center(
        child: FutureBuilder(
            future: requestStoragePermission(),
            builder: (context, snapshot) {
              return ElevatedButton(
                  onPressed: () async {
                    final filePath = await db.createDatabaseCopy(isExporting: true);
                    final (isSuccess, message) = await db.exportDatabase(filePath);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      duration: const Duration(seconds: 3),
                      backgroundColor: isSuccess ? Colors.green : Colors.red,
                    ));
                  },
                  child: const Text('Exportar'));
            }),
      ),
    );
  }
}
