import 'package:arnaldo/features/exportar/exportar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExportarModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const ExportarPage());
  }
}
