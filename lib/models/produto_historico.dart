class ProdutoHistorico {
  final int id;
  final int idProduto;
  final double preco;
  final String data;

  ProdutoHistorico({required this.id, required this.idProduto, required this.preco, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produto': idProduto,
      'preco': preco,
      'data': data,
    };
  }

  factory ProdutoHistorico.fromMap(Map<String, dynamic> map) {
    return ProdutoHistorico(
      id: map['id'],
      idProduto: map['id_produto'],
      preco: map['preco'],
      data: map['data'],
    );
  }

  ProdutoHistorico copyWith({
    int? id,
    int? idProduto,
    double? preco,
    String? data,
  }) {
    return ProdutoHistorico(
      id: id ?? this.id,
      idProduto: idProduto ?? this.idProduto,
      preco: preco ?? this.preco,
      data: data ?? this.data,
    );
  }
}
