import 'package:arnaldo/core/enums/operacao_type.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/features/operacoes/widgets/botao_menu_operacoes.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class OperacoesPage extends StatefulWidget {
  const OperacoesPage({super.key, required this.tipoOperacao});

  final OperacaoType tipoOperacao;

  @override
  State<OperacoesPage> createState() => _OperacoesPageState();
}

class _OperacoesPageState extends State<OperacoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Operacoes', hasLeading: true),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BotaoMenuOperacoes(texto: 'Clientes', icone: Icons.person, tipoPessoa: PessoaType.cliente),
                BotaoMenuOperacoes(texto: 'Fornecedores', icone: Icons.business, tipoPessoa: PessoaType.fornecedor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
