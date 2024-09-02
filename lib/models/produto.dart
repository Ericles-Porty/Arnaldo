class Produto {
  final int id;
  final String nome;
  final String tipo;

  Produto({required this.id, required this.nome, required this.tipo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
    );
  }
}
