import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/models/Dtos/produto_dto.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosController {
  Future<List<ProdutoDto>> fetchProdutos() async {
    final DatabaseHelper db = Modular.get<DatabaseHelper>();
    final List<ProdutoDto> produtos = await db.getProdutos().then((value) => value.map((e) => ProdutoDto.fromJson(e.toMap())).toList());
    return produtos;
  }
}
