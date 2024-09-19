import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OperacoesController {
  final ValueNotifier<DateTime> dataSelecionada = ValueNotifier<DateTime>(DateTime.now());

  String get dataSelecionadaFormatadaPadraoBr =>
      '${dataSelecionada.value.day.toString().padLeft(2, '0')}/${dataSelecionada.value.month.toString().padLeft(2, '0')}/${dataSelecionada.value.year}';

  Future<List<Pessoa>> fetchPessoas(PessoaType tipoPessoa) async {
    var db = Modular.get<DatabaseHelper>();
    return await db.getPessoas(tipoPessoa.name);
  }
}
