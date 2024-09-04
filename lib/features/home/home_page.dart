import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/models/Dtos/produto_dto.dart';
import 'package:arnaldo/models/produto_historico.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final DatabaseHelper db = Modular.get<DatabaseHelper>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<ProdutoDto>> _loadProdutos() async {
    final List<ProdutoDto> produtosDto = [];
    final produtos = await widget.db.getProdutos();
    for (var produto in produtos) {
      ProdutoHistorico produtoHistorico = await widget.db.getProdutoHistorico(idProduto: produto.id);
      produtosDto.add(ProdutoDto(id: produto.id, nome: produto.nome, valor: produtoHistorico.valor));
    }
    return produtosDto;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = screenSize.width * 0.15;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Arnaldo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    BotaoMenu(texto: 'Clientes', icone: Icons.person, rota: '/clientes/', size: size),
                    const SizedBox(width: 24),
                    BotaoMenu(texto: 'Fornecedores', icone: Icons.business, rota: '/fornecedores/', size: size),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    BotaoMenu(texto: 'Produtos', icone: Icons.inventory, rota: '/produtos/', size: size),
                    const SizedBox(width: 24),
                    BotaoMenu(texto: 'Vendas', icone: Icons.attach_money, rota: '/vendas/', size: size),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    BotaoMenu(texto: 'Compras', icone: Icons.shopping_cart, rota: '/compras/', size: size),
                    const SizedBox(width: 24),
                    BotaoMenu(texto: 'Relatório', icone: Icons.report, rota: '/relatorio/', size: size),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BotaoMenu extends StatelessWidget {
  const BotaoMenu({
    super.key,
    required this.size,
    required this.texto,
    required this.rota,
    required this.icone,
  });

  final String texto;
  final IconData icone;
  final String rota;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48),
            FittedBox(
              child: Text(
                texto,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Modular.to.pushNamed(rota);
      },
    );
  }
}
/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arnaldo', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _selectedIndex == 0
          ? FutureBuilder(
              future: _loadProdutos(),
              builder: (context, AsyncSnapshot<List<ProdutoDto>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  return ClientesPage(produtosDto: snapshot.data!);
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Vendas',
            icon: Icon(Icons.attach_money),
          ),
          BottomNavigationBarItem(
            label: 'Compras',
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: 'Produtos',
            icon: Icon(Icons.inventory),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Fornecedores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Relatório',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }*/
