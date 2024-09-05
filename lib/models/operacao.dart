import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/models/produto.dart';

class Operacao {
  final int id;
  final int idProdutoHistorico;
  final int idPessoa;
  final String tipo;
  final double quantidade;
  final double preco;
  final double desconto;
  final String data;
  final Pessoa? pessoa;
  final Produto? produto;

  Operacao(
      {required this.id,
      required this.idProdutoHistorico,
      required this.idPessoa,
      required this.tipo,
      required this.quantidade,
      required this.preco,
      required this.desconto,
      required this.data,
      this.pessoa,
      this.produto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produto_historico': idProdutoHistorico,
      'id_pessoa': idPessoa,
      'tipo': tipo,
      'quantidade': quantidade,
      'preco': preco,
      'desconto': desconto,
      'data': data
    };
  }

  factory Operacao.fromMap(Map<String, dynamic> map) {
    return Operacao(
      id: map['id'],
      idProdutoHistorico: map['id_produto_historico'],
      idPessoa: map['id_pessoa'],
      tipo: map['tipo'],
      quantidade: map['quantidade'],
      preco: map['preco'],
      desconto: map['desconto'],
      data: map['data'],
    );
  }

  Operacao copyWith({
    int? id,
    int? idProdutoHistorico,
    int? idPessoa,
    String? tipo,
    double? quantidade,
    double? preco,
    double? desconto,
    String? data,
  }) {
    return Operacao(
      id: id ?? this.id,
      idProdutoHistorico: idProdutoHistorico ?? this.idProdutoHistorico,
      idPessoa: idPessoa ?? this.idPessoa,
      tipo: tipo ?? this.tipo,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
      desconto: desconto ?? this.desconto,
      data: data ?? this.data,
    );
  }
}
