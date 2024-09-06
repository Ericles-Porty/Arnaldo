class ProdutoDto {
  final int id;
  final String nome;
  final double valor;


  ProdutoDto({
    required this.id,
    required this.nome,
    required this.valor,
  });

  factory ProdutoDto.fromJson(Map<String, dynamic> json) {
    return ProdutoDto(
      id: json['id'],
      nome: json['nome'],
      valor: json['valor'],
    );
  }
}
