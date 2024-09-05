import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/models/Dtos/produto_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosController {
  final ValueNotifier<DateTime> dataSelecionada = ValueNotifier<DateTime>(DateTime.now());

  String get dataSelecionadaFormatadaPadraoBr =>
      '${dataSelecionada.value.day.toString().padLeft(2, '0')}/${dataSelecionada.value.month.toString().padLeft(2, '0')}/${dataSelecionada.value.year}';

  Future<List<ProdutoDto>> fetchProdutos() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    final List<ProdutoDto> produtos = await db.getProdutos().then((value) => value.map((e) => ProdutoDto.fromJson(e.toMap())).toList());
    return produtos;
  }
}
