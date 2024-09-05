import 'package:sqflite/sqflite.dart';

Future<void> databaseSeed(Database db, int version) async {
  await db.insert('produto', {'nome': 'Pimenta de cheiro', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta-malagueta', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta doce', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta dedo de moça', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta chocolate', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta carolina reaper', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta biquinho', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Pimenta cumari', 'tipo': 'kg'});
  await db.insert('produto', {'nome': 'Quiabo branco', 'tipo': 'saco'});
  await db.insert('produto', {'nome': 'Quiabo verde', 'tipo': 'saco'});
  await db.insert('produto', {'nome': 'Quiabo precoce', 'tipo': 'saco'});
  await db.insert('produto', {'nome': 'Maxixe', 'tipo': 'saco'});
  await db.insert('produto', {'nome': 'Jiló', 'tipo': 'saco'});

  await db.insert('produto_historico', {'id_produto': 1, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 2, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 3, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 4, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 5, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 6, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 7, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 8, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 9, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 10, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 11, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 12, 'valor': 0.0, 'data': '2024-01-01'});
  await db.insert('produto_historico', {'id_produto': 13, 'valor': 0.0, 'data': '2024-01-01'});

  await db.insert('pessoa', {'nome': 'Leila', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Fernanda', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Nathalia', 'tipo': 'cliente'});
  await db.insert('pessoa', {'nome': 'Ericles', 'tipo': 'cliente'});

  await db.insert('pessoa', {'nome': 'Bosco', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Ricardo', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Rafael', 'tipo': 'fornecedor'});
  await db.insert('pessoa', {'nome': 'Nunes Peixoto', 'tipo': 'fornecedor'});
}