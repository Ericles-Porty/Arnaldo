import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/models/dtos/linha_produto_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosController {
  final ValueNotifier<DateTime> dataSelecionada = ValueNotifier<DateTime>(DateTime.now());
  List<LinhaProdutoDto> produtosPrecos = <LinhaProdutoDto>[];

  String get dataSelecionadaFormatadaPadraoBr =>
      '${dataSelecionada.value.day.toString().padLeft(2, '0')}/${dataSelecionada.value.month.toString().padLeft(2, '0')}/${dataSelecionada.value.year}';

  Future<List<LinhaProdutoDto>> fetchProdutosPrecos() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    produtosPrecos = await db.getProdutosPrecos(dataSelecionada.value);
    return produtosPrecos;
  }
}
