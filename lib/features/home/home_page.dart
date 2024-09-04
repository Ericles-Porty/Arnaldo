import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/features/home/widgets/botao_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final DatabaseHelper db = Modular.get<DatabaseHelper>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = screenSize.width * 0.3;
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
