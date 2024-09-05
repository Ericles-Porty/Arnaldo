import 'package:arnaldo/features/produtos/produtos_controller.dart';
import 'package:arnaldo/features/produtos/produtos_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(ProdutosController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const ProdutosPage());
  }
}
