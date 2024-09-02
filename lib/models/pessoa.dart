class Pessoa {
  final int id;
  final String nome;
  final String tipo;

  Pessoa({required this.id, required this.nome, required this.tipo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
    );
  }

  Pessoa copyWith({
    int? id,
    String? nome,
    String? tipo,
  }) {
    return Pessoa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
    );
  }
}
