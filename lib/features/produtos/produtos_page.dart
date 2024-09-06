import 'package:arnaldo/core/enums/produto_historico_type.dart';
import 'package:arnaldo/features/produtos/produtos_controller.dart';
import 'package:arnaldo/models/Dtos/linha_produto_dto.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:arnaldo/widgets/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  late ProdutosController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ProdutosController>();
    _controller.dataSelecionada.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Produtos'),
      body: ValueListenableBuilder(
          valueListenable: _controller.dataSelecionada,
          builder: (BuildContext context, DateTime value, Widget? child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _showDatePicker(context);
                        },
                        child: Text(
                          _controller.dataSelecionadaFormatadaPadraoBr,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                myDivider(context: context),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.4,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Produto',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.25,
                                  child: const Text(
                                    'Preço de compra',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.25,
                                  child: const Text(
                                    'Preço de venda',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      myDivider(context: context),
                      FutureBuilder(
                        future: _controller.fetchProdutosPrecos(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Erro: ${snapshot.error}'),
                            );
                          } else {
                            final List<LinhaProdutoDto> produtos = snapshot.data as List<LinhaProdutoDto>;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: produtos.length,
                                itemBuilder: (context, index) {
                                  final LinhaProdutoDto produto = produtos[index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.4,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: FittedBox(
                                                alignment: Alignment.centerLeft,
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  produto.nome,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.6,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.25,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showDialogEditarPreco(context: context, linhaProdutoDto: produto, tipo: ProdutoHistoricoType.compra);
                                                    },
                                                    child: Text(
                                                      'R\$${produto.precoCompra.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.25,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showDialogEditarPreco(context: context, linhaProdutoDto: produto, tipo: ProdutoHistoricoType.venda);
                                                    },
                                                    child: Text(
                                                      'R\$${produto.precoVenda.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      myDivider(context: context),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
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
    print('Data selecionada: $picked');
    if (picked != null && picked != _controller.dataSelecionada.value) {
      _controller.dataSelecionada.value = picked;
      print('Data selecionada: ${_controller.dataSelecionada.value}');
    }
  }

  Future<dynamic> _showDialogEditarPreco({
    required BuildContext context,
    required LinhaProdutoDto linhaProdutoDto,
    required ProdutoHistoricoType tipo,
  }) {
    double preco = tipo == ProdutoHistoricoType.compra ? linhaProdutoDto.precoCompra : linhaProdutoDto.precoVenda;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textEditingController = TextEditingController();
        return AlertDialog(
          title: Text('Editar preço de ${tipo.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Produto: ${linhaProdutoDto.nome}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Preço atual: R\$${preco.toStringAsFixed(2)}',
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
                  hintText: 'Digite o novo preço',
                  label: Text('Novo preço'),
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
                await _controller.editarPrecoProduto(idProduto: linhaProdutoDto.idProduto, tipo: tipo, preco: double.parse(textEditingController.text));
                await _controller.fetchProdutosPrecos();
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
