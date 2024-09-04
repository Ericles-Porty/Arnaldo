import 'package:arnaldo/features/clientes/clientes_module.dart';
import 'package:arnaldo/features/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage());
    r.module('/clientes', module: ClientesModule());
  }
}
