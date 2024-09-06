import 'package:arnaldo/core/enums/produto_historico_type.dart';

class LinhaProdutoDto {
  final String nome;
  late int idCompra;
  late int idVenda;
  late double precoCompra;
  late double precoVenda;
  final ProdutoHistoricoType tipo;

  LinhaProdutoDto({
    required this.nome,
    required this.idCompra,
    required this.idVenda,
    required this.precoCompra,
    required this.precoVenda,
    required this.tipo,
  });

  factory LinhaProdutoDto.fromJson(Map<String, dynamic> json) {
    return LinhaProdutoDto(
      nome: json['nome'],
      idCompra: json['id_compra'],
      idVenda: json['id_venda'],
      precoCompra: json['preco_compra'],
      precoVenda: json['preco_venda'],
      tipo: ProdutoHistoricoType.values[json['tipo']],
    );
  }
}
