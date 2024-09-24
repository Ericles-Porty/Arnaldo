import 'dart:io';

import 'package:arnaldo/core/database/database_ddl.dart';
import 'package:arnaldo/core/database/database_seed.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/core/utils.dart';
import 'package:arnaldo/features/operacoes/dtos/linha_operacao_dto.dart';
import 'package:arnaldo/models/dtos/linha_produto_dto.dart';
import 'package:arnaldo/models/operacao.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/models/produto.dart';
import 'package:arnaldo/models/produto_historico.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = 'arnaldo.db';
  static const String downloadFolderPath = '/storage/emulated/0/Download';
  static const String backupFolderPath = '/storage/emulated/0/Download/arnaldo/backups';
  static const String exportedFolderPath = '/storage/emulated/0/Download/arnaldo/exported';
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  Future<void> warmUp() async {
    print('Warming up database');
    await openDatabaseConnection();
    print('Database warmed up');
  }

  Future<void> fake() async{

  }

  DatabaseHelper._internal();

  Future<String> getDatabasePath() async {
    final directory = await getDatabasesPath();
    String path = join(directory, _databaseName);
    return path;
  }

  Future<String> createDatabaseCopy({bool isExporting = false}) async {
    final dbPath = await getDatabasePath();
    final dbFile = File(dbPath);

    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception('Não foi possível encontrar o diretório de armazenamento externo');

    // final backupFolderPath = '${directory.path}/backups';
    // final backupDirectory = Directory(backupFolderPath);
    // if (!(await backupDirectory.exists())) await backupDirectory.create(recursive: true);

    final folderPath = isExporting ? exportedFolderPath : backupFolderPath;
    final copyDirectory = Directory(folderPath);
    if (!(await copyDirectory.exists())) await copyDirectory.create(recursive: true);

    final dateNow = DateTime.now();
    final dataFormatada = formatarDataHoraPadraoUs(dateNow);
    final copyFilePath = '$folderPath/backup_$dataFormatada.db';
    await dbFile.copy(copyFilePath);
    return copyFilePath;
  }

  Future<(bool, String)> exportDatabase(String filePath) async {
    final shareResults = await Share.shareXFiles([XFile(filePath)]);
    if (shareResults.status == ShareResultStatus.success) return (true, 'Banco de dados exportado com sucesso.');
    if (shareResults.status == ShareResultStatus.dismissed) return (false, 'Exportação do banco de dados cancelada.');
    if (shareResults.status == ShareResultStatus.unavailable) return (false, 'Exportação do banco de dados indisponível.');
    return (false, 'Erro desconhecido ao exportar o banco de dados.');
  }

  Future<(bool, String)> importDatabase() async {
    // Seleciona o arquivo de backup
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    // Verifica se o arquivo foi selecionado
    if (result != null && result.files.single.path != null) {
      final pickedFilePath = result.files.single.path!;
      final pickedFile = File(pickedFilePath);

      // Verifica se o arquivo selecionado existe
      if (!await pickedFile.exists()) {
        return (false, 'Arquivo selecionado não encontrado.');
      }

      // Verifica se o arquivo selecionado é um arquivo de banco de dados
      if (extension(pickedFilePath) != '.db') {
        return (false, 'Arquivo selecionado não é um arquivo de banco de dados.');
      }

      // Copia o arquivo de banco de dados atual para um arquivo de backup
      await createDatabaseCopy();

      // Fechar a conexão com o banco de dados antes de substituir
      await closeDatabaseConnection();

      // Substitui o arquivo de banco de dados atual pelo arquivo importado
      final dbPath = await getDatabasePath();
      final copiedFile = await pickedFile.copy(dbPath);

      // Reinicializa a conexão com o banco de dados
      await openDatabaseConnection();

      return (true, 'Banco de dados importado com sucesso.');
    }
    return (false, 'Nenhum arquivo selecionado.');
  }

  Future<void> closeDatabaseConnection() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> openDatabaseConnection() async {
    _database ??= await _initDatabase();
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
      onOpen: _onOpen,
    );
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await databaseDdl(db, version);
    await databaseSeed(db, version);
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
    return await db.insert('pessoa', {'nome': nome, 'tipo': tipo, 'ativo': 1});
  }

  Future<int> updatePessoa(int id, String nome) async {
    final db = await database;
    return await db.update('pessoa', {'nome': nome}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePessoa(int id) async {
    final db = await database;
    return await db.delete('pessoa', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> togglePessoa(int id, bool ativo) async {
    final db = await database;
    return await db.update('pessoa', {'ativo': ativo ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  /// Produto
  Future<Produto> getProduto(int id) async {
    final db = await database;
    final response = await db.query('produto', where: 'id = ?', whereArgs: [id]);
    return Produto.fromMap(response.first);
  }

  Future<List<Produto>> getProdutos() async {
    final db = await database;
    final response = await db.query('produto', orderBy: 'nome');
    return response.map((produto) => Produto.fromMap(produto)).toList();
  }

  Future<int> insertProduto(String nome, String medida) async {
    final db = await database;
    return await db.insert('produto', {'nome': nome, 'medida': medida});
  }

  Future<int> updateProduto(int id, String nome, String medida) async {
    final db = await database;
    return await db.update('produto', {'nome': nome, 'medida': medida}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProduto(int id) async {
    final db = await database;
    return await db.delete('produto', where: 'id = ?', whereArgs: [id]);
  }

  /// Produto Historico
  Future<LinhaProdutoDto> getProdutoPreco(int idProduto, DateTime dataSelecionada) async {
    final db = await database;

    const produtoPrecoCompraQuery = '''
      SELECT 
        PR.nome,
        PH.id_produto,
        PH.preco,
        PH.tipo
      FROM produto_historico AS PH
      JOIN produto AS PR ON PR.id = PH.id_produto
      WHERE tipo = 'compra' AND PH.data = (SELECT MAX(data) FROM produto_historico WHERE tipo = 'compra' AND id_produto = PH.id_produto AND data <= ?) AND PH.id_produto = ?
    ''';

    final produtoPrecoCompraResponse = await db.rawQuery(produtoPrecoCompraQuery, [formatarDataPadraoUs(dataSelecionada), idProduto]);
    if (produtoPrecoCompraResponse.isEmpty) {
      throw Exception('Nenhum produto cadastrado até a data informada');
    }

    const produtoPrecoVentaQuery = '''
      SELECT 
        PR.nome,
        PH.id_produto,
        PH.preco,
        PH.tipo
      FROM produto_historico AS PH
      JOIN produto AS PR ON PR.id = PH.id_produto
      WHERE tipo = 'venda' AND PH.data = (SELECT MAX(data) FROM produto_historico WHERE tipo = 'venda' AND id_produto = PH.id_produto AND data <= ?) AND PH.id_produto = ?
    ''';

    final produtoPrecoVentaResponse = await db.rawQuery(produtoPrecoVentaQuery, [formatarDataPadraoUs(dataSelecionada), idProduto]);
    if (produtoPrecoVentaResponse.isEmpty) {
      throw Exception('Nenhum produto cadastrado até a data informada');
    }

    return LinhaProdutoDto(
      nome: produtoPrecoCompraResponse.first['nome'] as String,
      idProduto: produtoPrecoCompraResponse.first['id_produto'] as int,
      precoCompra: produtoPrecoCompraResponse.first['preco'] as double,
      precoVenda: produtoPrecoVentaResponse.first['preco'] as double,
    );
  }

  Future<List<LinhaProdutoDto>> getProdutosPrecos(DateTime dataSelecionada) async {
    final db = await database;

    const produtosPrecosCompraQuery = '''
      SELECT 
        PR.nome,
        PH.id_produto,
        PH.preco,
        PH.tipo
      FROM produto_historico AS PH
      JOIN produto AS PR ON PR.id = PH.id_produto
      WHERE tipo = 'compra' AND PH.data = (SELECT MAX(data) FROM produto_historico WHERE tipo = 'compra' AND id_produto = PH.id_produto AND data <= ?) 
    ''';

    const produtosPrecosVendaQuery = '''
      SELECT 
        PR.nome,
        PH.id_produto,
        PH.preco,
        PH.tipo
      FROM produto_historico AS PH
      JOIN produto AS PR ON PR.id = PH.id_produto
      WHERE tipo = 'venda' AND PH.data = (SELECT MAX(data) FROM produto_historico WHERE tipo = 'venda' AND id_produto = PH.id_produto AND data <= ?) 
    ''';

    List<Map<String, dynamic>> produtosPrecosCompraResponse = await db.rawQuery(produtosPrecosCompraQuery, [formatarDataPadraoUs(dataSelecionada)]);
    List<Map<String, dynamic>> produtosPrecosVentaResponse = await db.rawQuery(produtosPrecosVendaQuery, [formatarDataPadraoUs(dataSelecionada)]);
    List<Produto> produtos = await getProdutos();

    Map<String, LinhaProdutoDto> produtosPrecos = {};

    for (var produto in produtos) {
      produtosPrecos[produto.nome] = LinhaProdutoDto(nome: produto.nome, idProduto: produto.id, precoCompra: 0, precoVenda: 0);
    }

    for (var produtoHistorico in produtosPrecosCompraResponse) {
      produtosPrecos[produtoHistorico['nome']]!.precoCompra = produtoHistorico['preco'];
    }

    for (var produtoHistorico in produtosPrecosVentaResponse) {
      produtosPrecos[produtoHistorico['nome']]!.precoVenda = produtoHistorico['preco'];
    }

    return produtosPrecos.values.toList();
  }

  Future<ProdutoHistorico> getProdutoHistorico({required int idProduto, DateTime? data}) async {
    final db = await database;

    var query = 'SELECT * FROM produto_historico WHERE id_produto = ?';
    if (data != null) query += ' AND data <= ?';
    query += ' ORDER BY data DESC, id DESC LIMIT 1';

    final response = await db.rawQuery(query, data != null ? [idProduto, formatarDataPadraoUs(data)] : [idProduto]);

    if (response.isEmpty) {
      throw Exception('Nenhum produto cadastrado até a data informada');
    }

    return ProdutoHistorico.fromMap(response.first);
  }

  Future<int> insertProdutoHistorico(int idProduto, String tipo, double preco, DateTime data) async {
    final db = await database;

    final response =
        await db.query('produto_historico', where: 'id_produto = ? AND tipo = ? AND data = ?', whereArgs: [idProduto, tipo, formatarDataPadraoUs(data)]);

    if (response.isNotEmpty) {
      return await db.update('produto_historico', {'preco': preco}, where: 'id = ?', whereArgs: [response.first['id']]);
    }

    return await db.insert('produto_historico', {
      'id_produto': idProduto,
      'tipo': tipo,
      'preco': preco,
      'data': formatarDataPadraoUs(data),
    });
  }

  Future<int> updateProdutoHistorico(int id, double preco) async {
    final db = await database;
    return await db.update('produto_historico', {'preco': preco}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProdutoHistorico(int id) async {
    final db = await database;
    return await db.delete('produto_historico', where: 'id = ?', whereArgs: [id]);
  }

  /// Operacao

  Future<List<LinhaOperacaoDto>> getPessoaOperacoes({required DateTime data, required Pessoa pessoa}) async {
    final db = await database;

    final produtosPrecosResponse = await getProdutosPrecos(data);
    final produtosResponse = await getProdutos();

    List<LinhaOperacaoDto> operacoes = [];

    for (var produtoPreco in produtosPrecosResponse) {
      operacoes.add(LinhaOperacaoDto(
        produto: produtosResponse.firstWhere((element) => element.id == produtoPreco.idProduto),
        pessoa: pessoa,
        quantidade: 0,
        preco: pessoa.tipo == PessoaType.cliente.name ? produtoPreco.precoVenda : produtoPreco.precoCompra,
        desconto: 0,
        total: 0,
      ));
    }

    final response = await db.rawQuery('''
      SELECT 
        O.quantidade as quantidade,
        O.desconto as desconto,
        PR.id as id_produto,
        PR.nome as nome_produto,
        PR.medida as medida_produto,
        P.nome as nome_pessoa
      FROM operacao AS O
      JOIN produto_historico AS PH ON PH.id = O.id_produto_historico
      JOIN produto AS PR ON PR.id = PH.id_produto
      JOIN pessoa AS P ON P.id = O.id_pessoa
      WHERE O.id_pessoa = ? AND O.data = ?
    ''', [pessoa.id, formatarDataPadraoUs(data)]);

    for (var operacao in response) {
      final index = operacoes.indexWhere((element) => element.produto.nome == operacao['nome_produto']);
      operacoes[index] = operacoes[index].copyWith(
        quantidade: operacao['quantidade'] as double,
        preco: operacoes[index].preco,
        desconto: operacao['desconto'] as double,
        total: operacoes[index].preco * (operacao['quantidade'] as double) - (operacao['desconto'] as double),
      );
    }
    return operacoes;
  }

  Future<List<Operacao>> getOperacoesByDate({required DateTime data, required String tipo}) async {
    final db = await database;

    const operacaosByDateQuery = '''
      SELECT 
        O.*,
        P.nome as pessoa_nome,
        P.tipo as pessoa_tipo,
        P.ativo as pessoa_ativo,
        PR.id as produto_id,
        PR.nome as produto_nome,
        PR.tipo as produto_medida
      FROM operacao AS O
      JOIN pessoa AS P ON p.id = O.id_pessoa
      JOIN produto_historico AS PH ON ph.id = O.id_produto_historico
      JOIN produto AS PR ON pr.id = ph.id_produto
      WHERE V.data = ? AND P.tipo = ?
    ''';

    List<Map<String, dynamic>> operacaosResponse = await db.rawQuery(operacaosByDateQuery, [formatarDataPadraoUs(data), tipo]);

    return operacaosResponse.map((operacao) {
      final pessoa = Pessoa(id: operacao['id_pessoa'], nome: operacao['pessoa_nome'], tipo: operacao['pessoa_tipo'], ativo: operacao['pessoa_ativo']);
      final produto = Produto(id: operacao['produto_id'], nome: operacao['produto_nome'], medida: operacao['produto_medida']);

      return Operacao(
        id: operacao['id'],
        idProdutoHistorico: operacao['id_produto_historico'],
        idPessoa: operacao['id_pessoa'],
        tipo: operacao['tipo'],
        quantidade: operacao['quantidade'],
        preco: operacao['preco'],
        desconto: operacao['desconto'],
        data: operacao['data'],
        pessoa: pessoa,
        produto: produto,
      );
    }).toList();
  }

  Future<int> insertOperacao({
    required int idPessoa,
    required int idProduto,
    required String tipoOperacao,
    required double quantidade,
    required DateTime data,
    double desconto = 0,
  }) async {
    final db = await database;

    String dataFormatada = formatarDataPadraoUs(data);

    const lastProdutoHistoricoByDateQuery = '''
      SELECT * 
      FROM produto_historico 
      WHERE id_produto = ? AND tipo = ? AND data <= ? ORDER BY data DESC LIMIT 1
    ''';
    List<Map<String, dynamic>> produtoHistoricoResponse = await db.rawQuery(lastProdutoHistoricoByDateQuery, [idProduto, tipoOperacao, dataFormatada]);

    if (produtoHistoricoResponse.isEmpty) {
      throw Exception('Nenhum produto com preço até a data informada');
    }

    final produtoHistorico = ProdutoHistorico.fromMap(produtoHistoricoResponse.first);

    final operacaoResponse = await db.query('operacao', where: 'id_produto_historico = ? AND id_pessoa = ? AND data = ? AND tipo = ?', whereArgs: [
      produtoHistorico.id,
      idPessoa,
      dataFormatada,
      tipoOperacao,
    ]);

    if (operacaoResponse.isNotEmpty) {
      return await db.update(
          'operacao',
          {
            'quantidade': quantidade,
            'desconto': desconto,
          },
          where: 'id = ?',
          whereArgs: [operacaoResponse.first['id']]);
    }

    return await db.insert('operacao', {
      'id_produto_historico': produtoHistorico.id,
      'id_pessoa': idPessoa,
      'tipo': tipoOperacao,
      'quantidade': quantidade,
      'preco': produtoHistorico.preco,
      'desconto': desconto,
      'data': dataFormatada,
    });
  }

  Future<int> updateOperacao(int id, double quantidade) async {
    final db = await database;
    return await db.update('operacao', {'quantidade': quantidade}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateOperacaoDesconto(int id, double desconto) async {
    final db = await database;
    return await db.update('operacao', {'desconto': desconto}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOperacao(int id) async {
    final db = await database;
    return await db.delete('operacao', where: 'id = ?', whereArgs: [id]);
  }
}
