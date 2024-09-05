class Produto {
  final int id;
  final String nome;
  final String medida;

  Produto({required this.id, required this.nome, required this.medida});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'medida': medida,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      medida: map['medida'],
    );
  }
}
