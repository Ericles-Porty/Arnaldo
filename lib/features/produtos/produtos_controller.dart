import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/produto_historico_type.dart';
import 'package:arnaldo/models/Dtos/linha_produto_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosController {
  final ValueNotifier<DateTime> dataSelecionada = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<List<LinhaProdutoDto>> produtosPrecos = ValueNotifier<List<LinhaProdutoDto>>([]);


  String get dataSelecionadaFormatadaPadraoBr =>
      '${dataSelecionada.value.day.toString().padLeft(2, '0')}/${dataSelecionada.value.month.toString().padLeft(2, '0')}/${dataSelecionada.value.year}';

  Future<List<LinhaProdutoDto>> fetchProdutosPrecos() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    produtosPrecos.value = await db.getProdutosPrecos(dataSelecionada.value);
    return produtosPrecos.value;
  }

  Future<int> editarPrecoProduto({required int idProduto, required double preco, required ProdutoHistoricoType tipo}) async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    return await db.insertProdutoHistorico(idProduto, tipo.name, preco, dataSelecionada.value);
  }
}
