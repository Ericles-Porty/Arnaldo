import 'dart:io';

import 'package:arnaldo/models/Dtos/linha_venda_dto.dart';
import 'package:arnaldo/models/Produto.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/models/produto_historico.dart';
import 'package:arnaldo/models/venda.dart';
import 'package:arnaldo/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const String _databaseName = 'arnaldo.db';

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<String> getDatabasePath() async {
    final directory = await getDatabasesPath();
    String path = join(directory, _databaseName);
    return path;
  }

  Future<void> copyDatabase() async {    final dbPath = await getDatabasePath();
    final file = File(dbPath);
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/arnaldo/arnaldo_backup.db';
    await file.copy(newPath);
  }

  Future<void> shareDatabase(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produto(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        tipo TEXT
      )
    ''');

    await db.insert('produto', {'nome': 'Pimenta', 'tipo': 'kg'});
    await db.insert('produto', {'nome': 'Quiabo', 'tipo': 'saco'});
    await db.insert('produto', {'nome': 'Maxixe', 'tipo': 'saco'});
    await db.insert('produto', {'nome': 'Jiló', 'tipo': 'saco'});

    await db.execute('''
      CREATE TABLE pessoa(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        tipo TEXT
      )
    ''');

    await db.insert('pessoa', {'nome': 'João', 'tipo': 'cliente'});
    await db.insert('pessoa', {'nome': 'Maria', 'tipo': 'cliente'});
    await db.insert('pessoa', {'nome': 'José', 'tipo': 'cliente'});
    await db.insert('pessoa', {'nome': 'Pedro', 'tipo': 'cliente'});
    await db.insert('pessoa', {'nome': 'Ana', 'tipo': 'cliente'});

    await db.insert('pessoa', {'nome': 'João', 'tipo': 'fornecedor'});
    await db.insert('pessoa', {'nome': 'Maria', 'tipo': 'fornecedor'});
    await db.insert('pessoa', {'nome': 'José', 'tipo': 'fornecedor'});
    await db.insert('pessoa', {'nome': 'Pedro', 'tipo': 'fornecedor'});
    await db.insert('pessoa', {'nome': 'Ana', 'tipo': 'fornecedor'});

    await db.execute('''
      CREATE TABLE produto_historico(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto INTEGER,
        valor REAL,
        data TEXT,
        FOREIGN KEY (id_produto) REFERENCES produto (id)
      )
    ''');

    await db.insert('produto_historico', {'id_produto': 1, 'valor': 10.0, 'data': '2024-01-01'});
    await db.insert('produto_historico', {'id_produto': 2, 'valor': 20.0, 'data': '2024-01-01'});
    await db.insert('produto_historico', {'id_produto': 3, 'valor': 30.0, 'data': '2024-01-01'});
    await db.insert('produto_historico', {'id_produto': 4, 'valor': 40.0, 'data': '2024-01-01'});


    await db.execute('''
      CREATE TABLE venda(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto_historico INTEGER,
        id_pessoa INTEGER,
        quantidade REAL,
        preco REAL,
        valor REAL,   
        data TEXT,     
        FOREIGN KEY (id_produto_historico) REFERENCES produto_historico (id),
        FOREIGN KEY (id_pessoa) REFERENCES pessoa (id)
      )
    ''');

    await db.insert('venda', {'id_produto_historico': 1, 'id_pessoa': 1, 'quantidade': 1.0, 'preco': 10.0, 'valor': 10.0, 'data': '2024-08-31'});
    await db.insert('venda', {'id_produto_historico': 2, 'id_pessoa': 2, 'quantidade': 2.0, 'preco': 20.0, 'valor': 40.0, 'data': '2024-08-31'});
    await db.insert('venda', {'id_produto_historico': 3, 'id_pessoa': 3, 'quantidade': 3.0, 'preco': 30.0, 'valor': 90.0, 'data': '2024-08-31'});
    await db.insert('venda', {'id_produto_historico': 4, 'id_pessoa': 4, 'quantidade': 4.0, 'preco': 40.0, 'valor': 160.0, 'data': '2024-08-31'});

  }

  /// Pessoa
  Future<Pessoa> getPessoa(int id) async {
    final db = await database;
    final response = await db.query('pessoa', where: 'id = ?', whereArgs: [id]);
    return Pessoa.fromMap(response.first);
  }

  Future<List<Pessoa>> getPessoas(String tipo) async {
    final db = await database;
    final response = await db.query('pessoa', where: 'tipo = ?', orderBy: 'nome', whereArgs: [tipo]);
    return response.map((pessoa) => Pessoa.fromMap(pessoa)).toList();
  }

  Future<int> insertPessoa(String nome, String tipo) async {
    final db = await database;
    return await db.insert('pessoa', {'nome': nome, 'tipo': tipo});
  }

  Future<int> updatePessoa(int id, String nome, String tipo) async {
    final db = await database;
    return await db.update('pessoa', {'nome': nome, 'tipo': tipo}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePessoa(int id) async {
    final db = await database;
    return await db.delete('pessoa', where: 'id = ?', whereArgs: [id]);
  }

  /// Produto
  Future<Produto> getProduto(int id) async {
    final db = await database;
    final response = await db.query('produto', where: 'id = ?', whereArgs: [id]);
    return Produto.fromMap(response.first);
  }

  Future<List<Produto>> getProdutos() async {
    final db = await database;
    final response = await db.query('produto');
    return response.map((produto) => Produto.fromMap(produto)).toList();
  }

  Future<int> insertProduto(String nome, String tipo) async {
    final db = await database;
    return await db.insert('produto', {'nome': nome, 'tipo': tipo});
  }

  Future<int> updateProduto(int id, String nome, String tipo) async {
    final db = await database;
    return await db.update('produto', {'nome': nome, 'tipo': tipo}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProduto(int id) async {
    final db = await database;
    return await db.delete('produto', where: 'id = ?', whereArgs: [id]);
  }

  /// Produto Historico
  Future<ProdutoHistorico> getProdutoHistorico({required int idProduto, DateTime? data}) async {
    final db = await database;

    var query = 'SELECT * FROM produto_historico WHERE id_produto = ?';
    if (data != null) query += ' AND data <= ?';
    query += ' ORDER BY data DESC LIMIT 1';

    final response = await db.rawQuery(query, data != null ? [idProduto, getFormattedDate(data)] : [idProduto]);

    if (response.isEmpty) {
      throw Exception('Nenhum produto cadastrado até a data informada');
    }

    return ProdutoHistorico.fromMap(response.first);
  }

  Future<int> insertProdutoHistorico(int idProduto, double valor, DateTime data) async {
    final db = await database;

    return await db.insert('produto_historico', {
      'id_produto': idProduto,
      'valor': valor,
      'data': getFormattedDate(data),
    });
  }

  Future<int> updateProdutoHistorico(int id, double valor) async {
    final db = await database;
    return await db.update('produto_historico', {'valor': valor}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProdutoHistorico(int id) async {
    final db = await database;
    return await db.delete('produto_historico', where: 'id = ?', whereArgs: [id]);
  }

  /// Venda


  Future<List<Venda>> getVendasByDate({required DateTime data, required String tipo}) async{
    final db = await database;

    const vendasByDateQuery = '''
      SELECT 
        v.*,
        P.nome as pessoa_nome,
        P.tipo as pessoa_tipo,
        Pr.id as produto_id,
        PR.nome as produto_nome,
        PR.tipo as produto_tipo
      FROM venda AS V
      JOIN pessoa AS P ON p.id = v.id_pessoa
      JOIN produto_historico AS PH ON ph.id = v.id_produto_historico
      JOIN produto AS PR ON pr.id = ph.id_produto
      WHERE V.data = ? AND P.tipo = ?
    ''';

    List<Map<String, dynamic>> vendasResponse = await db.rawQuery(vendasByDateQuery, [getFormattedDate(data), tipo]);

    return vendasResponse.map((venda) {
      final pessoa = Pessoa(id: venda['id_pessoa'], nome: venda['pessoa_nome'], tipo: venda['pessoa_tipo']);
      final produto = Produto(id: venda['produto_id'], nome: venda['produto_nome'], tipo: venda['produto_tipo']);

      return Venda(
        id: venda['id'],
        idProdutoHistorico: venda['id_produto_historico'],
        idPessoa: venda['id_pessoa'],
        quantidade: venda['quantidade'],
        preco: venda['preco'],
        valor: venda['valor'],
        data: venda['data'],
        pessoa: pessoa,
        produto: produto,
      );
    }).toList();
  }

  Future<int> insertVenda(int idPessoa, int idProduto, double quantidade, DateTime data) async {
    final db = await database;

    String formattedDate = getFormattedDate(data);

    const lastProdutoHistoricoByDateQuery = '''
      SELECT * 
      FROM produto_historico 
      WHERE id_produto = ? AND 
      data <= ? ORDER BY data DESC LIMIT 1
    ''';
    List<Map<String, dynamic>> produtoHistoricoResponse = await db.rawQuery(lastProdutoHistoricoByDateQuery, [idProduto, formattedDate]);

    if (produtoHistoricoResponse.isEmpty) {
      throw Exception('Nenhum produto cadastrado até a data informada');
    }

    final produtoHistorico = ProdutoHistorico.fromMap(produtoHistoricoResponse.first);

    return await db.insert('venda', {
      'id_produto_historico': produtoHistorico.id,
      'id_pessoa': idPessoa,
      'quantidade': quantidade,
      'preco': produtoHistorico.valor,
      'valor': quantidade * produtoHistorico.valor,
      'data': formattedDate,
    });
  }

  Future<int> updateVenda(int id, double quantidade) async {
    final db = await database;
    return await db.update('venda', {'quantidade': quantidade}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteVenda(int id) async {
    final db = await database;
    return await db.delete('venda', where: 'id = ?', whereArgs: [id]);
  }
}
