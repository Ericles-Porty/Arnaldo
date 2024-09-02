import 'package:arnaldo/models/Produto.dart';
import 'package:arnaldo/models/pessoa.dart';

class Venda {
  final int id;
  final int idProdutoHistorico;
  final int idPessoa;
  final double quantidade;
  final double preco;
  final double valor;
  final String data;
  final Pessoa? pessoa;
  final Produto? produto;

  Venda(
      {required this.id,
      required this.idProdutoHistorico,
      required this.idPessoa,
      required this.quantidade,
      required this.preco,
      required this.valor,
      required this.data,
      this.pessoa,
      this.produto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produto_historico': idProdutoHistorico,
      'id_pessoa': idPessoa,
      'quantidade': quantidade,
      'preco': preco,
      'valor': valor,
      'data': data
    };
  }

  factory Venda.fromMap(Map<String, dynamic> map) {
    return Venda(
      id: map['id'],
      idProdutoHistorico: map['id_produto_historico'],
      idPessoa: map['id_pessoa'],
      quantidade: map['quantidade'],
      preco: map['preco'],
      valor: map['valor'],
      data: map['data'],
    );
  }

  Venda copyWith({
    int? id,
    int? idProdutoHistorico,
    int? idPessoa,
    double? quantidade,
    double? preco,
    double? valor,
    String? data,
  }) {
    return Venda(
      id: id ?? this.id,
      idProdutoHistorico: idProdutoHistorico ?? this.idProdutoHistorico,
      idPessoa: idPessoa ?? this.idPessoa,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
      valor: valor ?? this.valor,
      data: data ?? this.data,
    );
  }
}
