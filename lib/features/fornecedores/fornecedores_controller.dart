import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FornecedoresController {
  List<Pessoa> _fornecedores = [];

  List<Pessoa> get fornecedores => _fornecedores;

  Future<List<Pessoa>> fetchFornecedores() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    final List<Pessoa> fornecedores = await db.getPessoas(PessoaType.fornecedor.name);
    _fornecedores = fornecedores;
    return _fornecedores;
  }
}
