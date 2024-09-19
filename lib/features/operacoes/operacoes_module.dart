import 'package:arnaldo/core/enums/operacao_type.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/features/operacoes/operacoes_controller.dart';
import 'package:arnaldo/features/operacoes/operacoes_page.dart';
import 'package:arnaldo/features/operacoes/widgets/lista_operacoes_pessoa_page.dart';
import 'package:arnaldo/features/operacoes/widgets/lista_pessoas_page.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OperacoesModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(OperacoesController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => OperacoesPage(tipoOperacao: r.args.data as OperacaoType));
    r.child('/pessoas', child: (context) => ListaPessoasPage(tipoPessoa: r.args.data as PessoaType));
    r.child('/pessoa', child: (context) => ListaOperacoesPessoaPage(pessoa: r.args.data as Pessoa));
  }
}
