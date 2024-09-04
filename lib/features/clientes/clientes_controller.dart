import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClientesController {
  List<Pessoa> _clientes = [];

  List<Pessoa> get clientes => _clientes;

  Future<void> fetchClientes() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    final List<Pessoa> clientes = await db.getPessoas(PessoaType.cliente.name);
    _clientes = clientes;
  }
}
