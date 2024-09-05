// import 'package:arnaldo/core/database/database_helper.dart';
// import 'package:flutter/material.dart';
//
// Container celula({required String texto, required double width, double? height = 50, Color cor = Colors.white}) {
//   final textoTratado = texto.replaceAll(" ", "\n");
//   return Container(
//     width: width,
//     height: height,
//     padding: const EdgeInsets.all(4),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.black),
//       color: cor,
//     ),
//     child: Center(
//         child: FittedBox(
//             child: Text(
//       texto,
//       textAlign: TextAlign.center,
//       style: const TextStyle(fontSize: 20),
//     ))),
//   );
// }
//
// showDialogEditarPreco({required BuildContext context, required int idProduto, required Function() setState, required DateTime dataSelecionada}) {
//   final TextEditingController controller = TextEditingController();
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Editar preço'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(labelText: 'Preço'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancelar'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Salvar'),
//             onPressed: () {
//               // Testar botar async
//               final db = DatabaseHelper();
//               double novoPreco = double.parse(controller.text);
//               db.insertProdutoHistorico(idProduto, novoPreco, dataSelecionada);
//               Navigator.of(context).pop();
//               setState();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// Container celulaColunaPrecoEditavel({required String texto, required double width, double? height = 50, required Function() onTap}) {
//   final TextEditingController controller = TextEditingController(text: texto);
//   return Container(
//     width: width,
//     height: height,
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey),
//     ),
//     child: InkWell(
//       onTap: onTap,
//       child: Center(child: FittedBox(child: Text(texto, textAlign: TextAlign.center))),
//     ),
//   );
// }
//
// showDialogEditarQuantidade(
//     {required BuildContext context,
//     required TextEditingController controller,
//     required int? idVenda,
//     required int? idPessoa,
//     required int? idProduto,
//     required Function() setState,
//     required DateTime dataSelecionada}) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Editar quantidade'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(labelText: 'Quantidade'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancelar'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Salvar'),
//             onPressed: () {
//               final db = DatabaseHelper();
//               double novaQuantidade = double.parse(controller.text);
//               if (idVenda == null) {
//                 db.insertVenda(idPessoa!, idProduto!, novaQuantidade, dataSelecionada); // Lembrar de tirar o 0
//               } else {
//                 db.updateVenda(idVenda, novaQuantidade);
//               }
//               Navigator.of(context).pop();
//               setState();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// Container celulaLinhaVendaEditavel({required String texto, required double width, double? height = 50, required Function() onTap}) {
//   final TextEditingController controller = TextEditingController(text: texto);
//   return Container(
//     width: width,
//     height: height,
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey),
//     ),
//     child: InkWell(
//       onTap: onTap,
//       child: Center(child: FittedBox(child: Text(texto, textAlign: TextAlign.center))),
//     ),
//   );
// }
//
// showDialogOpcoesPessoa({required BuildContext context, required int idPessoa, required Function() setState}) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Opções'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             ElevatedButton(
//               child: const Text('Editar'),
//               onPressed: () {
//                 final TextEditingController controller = TextEditingController();
//                 showDialogEditarPessoa(context: context, controller: controller, idPessoa: idPessoa, setState: setState);
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Excluir'),
//               onPressed: () {
//                 final db = DatabaseHelper();
//                 db.deletePessoa(idPessoa);
//                 Navigator.of(context).pop();
//                 setState();
//               },
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancelar'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// showDialogEditarPessoa({required BuildContext context, required TextEditingController controller, required int idPessoa, required Function() setState}) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Editar pessoa'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(labelText: 'Nome'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancelar'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Salvar'),
//             onPressed: () {
//               final db = DatabaseHelper();
//               db.updatePessoa(idPessoa, controller.text);
//               Navigator.of(context).pop();
//               setState();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// Container celulaLinhaPessoaEditavel({required String texto, required double width, double? height = 50, required Function() onTap}) {
//   final TextEditingController controller = TextEditingController(text: texto);
//   return Container(
//     width: width,
//     height: height,
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey),
//     ),
//     child: InkWell(
//       onTap: onTap,
//       child: Center(child: FittedBox(child: Text(texto, textAlign: TextAlign.center))),
//     ),
//   );
// }
