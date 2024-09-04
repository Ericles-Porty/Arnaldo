class ProdutoHistorico {
  final int id;
  final int idProduto;
  final double valor;
  final String data;

  ProdutoHistorico({required this.id, required this.idProduto, required this.valor, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produto': idProduto,
      'valor': valor,
      'data': data,
    };
  }

  factory ProdutoHistorico.fromMap(Map<String, dynamic> map) {
    return ProdutoHistorico(
      id: map['id'],
      idProduto: map['id_produto'],
      valor: map['valor'],
      data: map['data'],
    );
  }

  ProdutoHistorico copyWith({
    int? id,
    int? idProduto,
    double? valor,
    String? data,
  }) {
    return ProdutoHistorico(
      id: id ?? this.id,
      idProduto: idProduto ?? this.idProduto,
      valor: valor ?? this.valor,
      data: data ?? this.data,
    );
  }
}
