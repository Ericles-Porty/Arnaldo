import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/models/produto.dart';

class LinhaOperacaoDto {
  final Produto produto;
  final Pessoa pessoa;
  final double quantidade;
  final double preco;
  final double desconto;
  final double total;
  final String? comentario;

  LinhaOperacaoDto({
    required this.produto,
    required this.pessoa,
    required this.quantidade,
    required this.preco,
    required this.desconto,
    required this.total,
    this.comentario,
  });

  factory LinhaOperacaoDto.fromMap(Map<String, dynamic> map) {
    return LinhaOperacaoDto(
      produto: Produto(id: map['id_produto'], nome: map['nome_produto'], medida: map['medida_produto']),
      pessoa: Pessoa(id: map['id_pessoa'], nome: map['nome_pessoa'], tipo: map['tipo_pessoa'], ativo: map['ativo_pessoa']),
      quantidade: map['quantidade'],
      preco: map['preco'],
      desconto: map['desconto'],
      total: map['total'],
      comentario: map['comentario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_produto': produto.id,
      'nome_produto': produto.nome,
      'medida_produto': produto.medida,
      'id_pessoa': pessoa.id,
      'nome_pessoa': pessoa.nome,
      'tipo_pessoa': pessoa.tipo,
      'ativo_pessoa': pessoa.ativo,
      'quantidade': quantidade,
      'preco': preco,
      'desconto': desconto,
      'total': total,
      'comentario': comentario,
    };
  }

  LinhaOperacaoDto copyWith({
    Produto? produto,
    Pessoa? pessoa,
    double? quantidade,
    double? preco,
    double? desconto,
    double? total,
    String? comentario,
  }) {
    return LinhaOperacaoDto(
      produto: produto ?? this.produto,
      pessoa: pessoa ?? this.pessoa,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
      desconto: desconto ?? this.desconto,
      total: total ?? this.total,
      comentario: comentario ?? this.comentario,
    );
  }
}
