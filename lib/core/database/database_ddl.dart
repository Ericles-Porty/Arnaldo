import 'package:sqflite/sqflite.dart';

Future<void> databaseDdl(Database db, int version) async {
  // Produto
  // Medida: kg, saco
  await db.execute('''
      CREATE TABLE produto(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        medida TEXT
      )
    ''');

  // Pessoa
  // Tipo: cliente, fornecedor
  await db.execute('''
      CREATE TABLE pessoa(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        tipo TEXT,
        ativo INTEGER DEFAULT 1
      )
    ''');

  // Produto histórico
  // Tipo: compra, venda
  await db.execute('''
      CREATE TABLE produto_historico(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto INTEGER,
        preco REAL,
        tipo TEXT,
        data TEXT,
        FOREIGN KEY (id_produto) REFERENCES produto (id)
      )
    ''');

  // Operacao
  // Tipo: compra, venda
  await db.execute('''
      CREATE TABLE Operacao(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto_historico INTEGER,
        id_pessoa INTEGER,
        quantidade REAL,
        preco REAL,
        valor REAL,   
        data TEXT,   
        tipo TEXT, 
        desconto REAL,
        FOREIGN KEY (id_produto_historico) REFERENCES produto_historico (id),
        FOREIGN KEY (id_pessoa) REFERENCES pessoa (id)
      )
    ''');
}
