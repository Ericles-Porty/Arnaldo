import 'package:arnaldo/features/importar/importar_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ImportarModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const ImportarPage());
  }
}
