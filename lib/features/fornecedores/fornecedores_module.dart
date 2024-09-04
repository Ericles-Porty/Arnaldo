import 'package:arnaldo/features/fornecedores/fornecedores_controller.dart';
import 'package:arnaldo/features/fornecedores/fornecedores_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FornecedoresModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FornecedoresController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const FornecedoresPage());
  }
}
