import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/core/enums/rota.dart';
import 'package:arnaldo/features/pessoas/pessoas_controller.dart';
import 'package:arnaldo/features/pessoas/pessoas_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PessoasModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(PessoasController.new);
  }

  @override
  void routes(r) {
    r.child('/${Rota.clientes.name}', child: (context) => const PessoasPage(pessoaType: PessoaType.cliente));
    r.child('/${Rota.fornecedores.name}', child: (context) => const PessoasPage(pessoaType: PessoaType.fornecedor));
  }
}
