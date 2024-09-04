import 'package:arnaldo/features/clientes/clientes_controller.dart';
import 'package:arnaldo/features/clientes/clientes_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClientesModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(ClientesController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const ClientesPage());
  }
}
