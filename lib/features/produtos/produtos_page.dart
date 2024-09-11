import 'package:arnaldo/features/produtos/produtos_controller.dart';
import 'package:arnaldo/features/produtos/widgets/linha_produto.dart';
import 'package:arnaldo/models/dtos/linha_produto_dto.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:arnaldo/widgets/my_divider.dart';
import 'package:arnaldo/widgets/my_vertical_divider.dart';
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
    print('ProdutosPage.initState');
    _controller = Modular.get<ProdutosController>();
  }

  @override
  Widget build(BuildContext context) {
    print('ProdutosPage.build');
    print('Data selecionada: ${_controller.dataSelecionada.value}');
    Size size = MediaQuery.of(context).size;
    print('ProdutosPage.build.size: $size');
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: 'Produtos',
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
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: _controller.dataSelecionada,
          builder: (BuildContext context, DateTime value, Widget? child) {
            return Column(
              children: [
                myDivider(context: context),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.50,
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
                          myVerticalDivider(size: size),
                          SizedBox(
                            width: size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.175,
                                  child: const Text(
                                    'Preço compra',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                myVerticalDivider(size: size),
                                SizedBox(
                                  width: size.width * 0.175,
                                  child: const Text(
                                    'Preço venda',
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
                            return const Expanded(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Expanded(
                              child: Center(
                                child: Text('Erro: ${snapshot.error}'),
                              ),
                            );
                          } else {
                            final List<LinhaProdutoDto> produtos = snapshot.data as List<LinhaProdutoDto>;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: produtos.length,
                                itemBuilder: (context, index) {
                                  final LinhaProdutoDto produto = produtos[index];
                                  final color = index % 2 == 0 ? Theme.of(context).scaffoldBackgroundColor : Colors.grey[200];
                                  return LinhaProduto(produto: produto, dataSelecionada: _controller.dataSelecionada.value, backgroundColor: color);
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

    if (picked != null && picked != _controller.dataSelecionada.value) {
      print('picked: $picked');
      _controller.dataSelecionada.value = picked;
    }
  }
}
