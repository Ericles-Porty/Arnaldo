import 'package:arnaldo/core/enums/rota.dart';
import 'package:arnaldo/features/clientes/clientes_module.dart';
import 'package:arnaldo/features/fornecedores/fornecedores_module.dart';
import 'package:arnaldo/features/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage());
    r.child('/${Rota.home.name}', child: (context) => HomePage());
    r.module('/${Rota.clientes.name}', module: ClientesModule());
    r.module('/${Rota.fornecedores.name}', module: FornecedoresModule());
  }
}
