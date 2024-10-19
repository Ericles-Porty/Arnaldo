import 'package:sqflite/sqflite.dart';

Future<void> databaseSeed(Database db, int version) async {
  await db.insert('produto', {'nome': 'Pimenta de cheiro', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Pimenta doce', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Pimenta-malagueta', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta dedo de moça', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta chocolate', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta carolina reaper', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta biquinho', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta cumari', 'medida': 'kg'});
  await db.insert('produto', {'nome': 'Quiabo branco', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Quiabo verde', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Quiabo precoce', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Maxixe', 'medida': 'saco'});
  await db.insert('produto', {'nome': 'Jiló', 'medida': 'saco'});

  await db.insert('produto_historico', {'id_produto': 1, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 2, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 3, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 4, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 5, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 6, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 7, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 8, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 9, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 10, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 11, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 12, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});
  await db.insert('produto_historico', {'id_produto': 13, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'compra'});

  await db.insert('produto_historico', {'id_produto': 1, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 2, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 3, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 4, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 5, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 6, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 7, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 8, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 9, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 10, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 11, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 12, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});
  await db.insert('produto_historico', {'id_produto': 13, 'preco': 0.0, 'data': '2024-01-01', 'tipo': 'venda'});

  await db.insert('pessoa', {'nome': 'Leila', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Fernanda', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Nathalia', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Ericles', 'tipo': 'cliente'});

  await db.insert('pessoa', {'nome': 'Bosco', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Ricardo', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Rafael', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Nunes Peixoto', 'tipo': 'fornecedor'});
}
