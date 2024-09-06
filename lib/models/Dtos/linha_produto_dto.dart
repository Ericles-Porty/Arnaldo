class LinhaProdutoDto {
  final String nome;
  final int idProduto;
  late double precoCompra;
  late double precoVenda;

  LinhaProdutoDto({
    required this.nome,
    required this.idProduto,
    required this.precoCompra,
    required this.precoVenda,
  });

  factory LinhaProdutoDto.fromJson(Map<String, dynamic> json) {
    return LinhaProdutoDto(
      nome: json['nome'],
      idProduto: json['id_produto'],
      precoCompra: json['preco_compra'],
      precoVenda: json['preco_venda'],
    );
  }
}
