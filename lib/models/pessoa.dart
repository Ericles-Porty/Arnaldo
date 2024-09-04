class Pessoa {
  final int id;
  final String nome;
  final String tipo;
  final bool ativo;

  Pessoa({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.ativo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'ativo': ativo,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      ativo: map['ativo'] == 1,
    );
  }

  Pessoa copyWith({
    int? id,
    String? nome,
    String? tipo,
    bool? ativo,
  }) {
    return Pessoa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      ativo: ativo ?? this.ativo,
    );
  }
}
