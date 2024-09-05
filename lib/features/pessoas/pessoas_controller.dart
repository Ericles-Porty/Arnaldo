import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PessoasController {

  List<Pessoa> _pessoas = [];

  List<Pessoa> get pessoas => _pessoas;

  Future<List<Pessoa>> fetchPessoas(PessoaType pessoaType) async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    _pessoas = await db.getPessoas(pessoaType.name);
    return _pessoas;
  }
}
