import 'package:arnaldo/core/utils.dart';
import 'package:arnaldo/features/operacoes/dtos/linha_operacao_dto.dart';
import 'package:arnaldo/features/operacoes/operacoes_controller.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:arnaldo/widgets/my_divider.dart';
import 'package:arnaldo/widgets/my_vertical_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListaOperacoesPessoaPage extends StatefulWidget {
  const ListaOperacoesPessoaPage({super.key, required this.pessoa});

  final Pessoa pessoa;

  @override
  State<ListaOperacoesPessoaPage> createState() => _ListaOperacoesPessoaPageState();
}

class _ListaOperacoesPessoaPageState extends State<ListaOperacoesPessoaPage> {
  late OperacoesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<OperacoesController>();
  }

  @override
  Widget build(BuildContext context) {
    final tipoOperacao = widget.pessoa.tipo == 'cliente' ? 'Compras' : 'Vendas';
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: '$tipoOperacao de ${widget.pessoa.nome}',
        hasLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker(context);
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _controller.dataSelecionada,
                    builder: (BuildContext context, DateTime data, Widget? child) {
                      return Text(
                        _controller.dataSelecionadaFormatadaPadraoBr,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context) {
                      final size = MediaQuery.of(context).size;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.2,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Quantidade',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          myVerticalDivider(size: size),
                          SizedBox(
                            width: size.width * 0.2,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Preço',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          myVerticalDivider(size: size),
                          SizedBox(
                            width: size.width * 0.2,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Desconto',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          myVerticalDivider(size: size),
                          SizedBox(
                            width: size.width * 0.2,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Total',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          myDivider(context: context, indent: 0),
          ValueListenableBuilder(
              valueListenable: _controller.dataSelecionada,
              builder: (BuildContext context, DateTime data, Widget? child) {
                return FutureBuilder(
                  future: _controller.fetchOperacoes(widget.pessoa),
                  builder: (BuildContext context, AsyncSnapshot<List<LinhaOperacaoDto>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(child: Center(child: CircularProgressIndicator()));
                    }
                    if (snapshot.hasError) {
                      return const Expanded(child: Center(child: Text('Erro ao carregar operacoes')));
                    }
                    final size = MediaQuery.of(context).size;
                    final operacoes = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: operacoes.length,
                        itemBuilder: (context, index) {
                          final operacao = operacoes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 3,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              operacao.produto.nome,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: myDivider(context: context, indent: 0),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _showDialogEditarQuantidade(context: context, linhaOperacaoDto: operacao);
                                        },
                                        child: SizedBox(
                                          width: size.width * 0.2,
                                          child: Text(
                                            '${formatarValorMonetario(operacao.quantidade)} ${operacao.produto.medida}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      myVerticalDivider(size: size),
                                      SizedBox(
                                        width: size.width * 0.2,
                                        child: Text(
                                          'R\$${formatarValorMonetario(operacao.preco)}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      myVerticalDivider(size: size),
                                      InkWell(
                                        onTap: () async {
                                          await _showDialogEditarDesconto(context: context, linhaOperacaoDto: operacao);
                                        },
                                        child: SizedBox(
                                          width: size.width * 0.2,
                                          child: Text(
                                            'R\$${formatarValorMonetario(operacao.desconto)}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      myVerticalDivider(size: size),
                                      SizedBox(
                                        width: size.width * 0.2,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'R\$${formatarValorMonetario(operacao.total)}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.dataSelecionada.value,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null && picked != _controller.dataSelecionada.value) {
      _controller.dataSelecionada.value = picked;
    }
  }

  Future<dynamic> _showDialogEditarQuantidade({
    required BuildContext context,
    required LinhaOperacaoDto linhaOperacaoDto,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final textoInicial = formatarValorMonetarioOuVazio(linhaOperacaoDto.quantidade);
        TextEditingController textEditingController = TextEditingController(text: textoInicial);
        return AlertDialog(
          title: const Text('Editar quantidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Pessoa: ${linhaOperacaoDto.pessoa.nome}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Produto: ${linhaOperacaoDto.produto.nome}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Preço atual: R\$${linhaOperacaoDto.preco}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Digite a nova quantidade',
                  label: Text('Nova quantidade'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _controller.salvarOperacao(linhaOperacaoDto.copyWith(
                  quantidade: double.parse(textEditingController.text),
                ));
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showDialogEditarDesconto({
    required BuildContext context,
    required LinhaOperacaoDto linhaOperacaoDto,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final textoInicial = formatarValorMonetarioOuVazio(linhaOperacaoDto.desconto);
        TextEditingController textEditingController = TextEditingController(text: textoInicial);
        return AlertDialog(
          title: const Text('Editar desconto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Pessoa: ${linhaOperacaoDto.pessoa.nome}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Produto: ${linhaOperacaoDto.produto.nome}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Preço atual: R\$${linhaOperacaoDto.preco}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Digite o novo desconto',
                  label: Text('Novo desconto'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _controller.salvarOperacao(linhaOperacaoDto.copyWith(
                  desconto: double.parse(textEditingController.text),
                ));
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
