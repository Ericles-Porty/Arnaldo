import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/produto_historico_type.dart';
import 'package:arnaldo/models/dtos/linha_produto_dto.dart';
import 'package:arnaldo/widgets/my_divider.dart';
import 'package:arnaldo/widgets/my_vertical_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutoController {
  ProdutoController({required LinhaProdutoDto produto, required this.dataSelecionada}) : produto = ValueNotifier<LinhaProdutoDto>(produto);
  final ValueNotifier<LinhaProdutoDto> produto;
  final DateTime dataSelecionada;

  Future<LinhaProdutoDto> fetchProdutoPreco() async {
    final db = Modular.get<DatabaseHelper>();
    produto.value = await db.getProdutoPreco(produto.value.idProduto, dataSelecionada);
    return produto.value;
  }

  Future<int> editarPrecoProduto({required int idProduto, required double preco, required ProdutoHistoricoType tipo}) async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    return await db.insertProdutoHistorico(idProduto, tipo.name, preco, dataSelecionada);
  }
}

class LinhaProduto extends StatefulWidget {
  const LinhaProduto({super.key, required this.produto, required this.dataSelecionada, this.backgroundColor});

  final LinhaProdutoDto produto;
  final DateTime dataSelecionada;
  final Color? backgroundColor;

  @override
  State<LinhaProduto> createState() => _LinhaProdutoState();
}

class _LinhaProdutoState extends State<LinhaProduto> {
  late ProdutoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProdutoController(produto: widget.produto, dataSelecionada: widget.dataSelecionada);
    _controller.produto.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.produto.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ValueListenableBuilder<LinhaProdutoDto>(
        valueListenable: _controller.produto,
        builder: (context, produto, child) {
          return Column(
            children: [
              Container(
                color: widget.backgroundColor,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            produto.nome,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    myVerticalDivider(size: size),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.175,
                            child: InkWell(
                              onTap: () async {
                                await _showDialogEditarPreco(context: context, linhaProdutoDto: produto, tipo: ProdutoHistoricoType.compra);
                              },
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'R\$${produto.precoCompra.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          myVerticalDivider(size: size),
                          SizedBox(
                            width: size.width * 0.175,
                            child: InkWell(
                              onTap: () async {
                                await _showDialogEditarPreco(context: context, linhaProdutoDto: produto, tipo: ProdutoHistoricoType.venda);
                              },
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'R\$${produto.precoVenda.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              myDivider(context: context),
            ],
          );
        });
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
                await _controller.fetchProdutoPreco();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
