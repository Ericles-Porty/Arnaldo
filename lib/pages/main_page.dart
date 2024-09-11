// import 'package:arnaldo/core/database/database_helper.dart';
// import 'package:arnaldo/models/dtos/produto_dto.dart';
// import 'package:arnaldo/models/produto_historico.dart';
// import 'package:arnaldo/pages/clientes_page.dart';
// import 'package:arnaldo/widgets/my_app_bar.dart';
// import 'package:flutter/material.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   final db = DatabaseHelper();
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   Future<List<ProdutoDto>> _loadProdutos() async {
//     final List<ProdutoDto> produtosDto = [];
//     final produtos = await db.getProdutos();
//     for (var produto in produtos) {
//       ProdutoHistorico produtoHistorico = await db.getProdutoHistorico(idProduto: produto.id);
//       produtosDto.add(ProdutoDto(id: produto.id, nome: produto.nome, valor: produtoHistorico.valor));
//     }
//     return produtosDto;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar(context: context, title: 'Arnaldo'),
//       body: _selectedIndex == 0
//           ? FutureBuilder(
//               future: _loadProdutos(),
//               builder: (context, AsyncSnapshot<List<ProdutoDto>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Erro: ${snapshot.error}'));
//                 } else {
//                   return ClientesPage(produtosDto: snapshot.data!);
//                 }
//               },
//             )
//           : null,
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Clientes',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Fornecedores',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.report),
//             label: 'Relatório',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
