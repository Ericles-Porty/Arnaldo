class LinhaVendaDto {
  final int idPessoa;
  final String nomePessoa;
  final int idPimenta;
  final int? idVendaPimenta;
  final double quantidadePimenta;
  final int idQuiabo;
  final int? idVendaQuiabo;
  final double quantidadeQuiabo;
  final int idMaxixe;
  final int? idVendaMaxixe;
  final double quantidadeMaxixe;
  final int idJilo;
  final int? idVendaJilo;
  final double quantidadeJilo;

  LinhaVendaDto({
    required this.idPessoa,
    required this.nomePessoa,
    required this.idPimenta,
    this.idVendaPimenta,
    required this.quantidadePimenta,
    required this.idQuiabo,
    this.idVendaQuiabo,
    required this.quantidadeQuiabo,
    required this.idMaxixe,
    this.idVendaMaxixe,
    required this.quantidadeMaxixe,
    required this.idJilo,
    this.idVendaJilo,
    required this.quantidadeJilo,
  });
  
  factory LinhaVendaDto.fromMap(Map<String, dynamic> map) {
    return LinhaVendaDto(
      idPessoa: map['id_pessoa'],
      nomePessoa: map['nome_pessoa'],
      idPimenta: map['id_pimenta'],
      idVendaPimenta: map['id_pimenta'],
      quantidadePimenta: map['quantidade_pimenta'],
      idQuiabo: map['id_quiabo'],
      idVendaQuiabo: map['id_quiabo'],
      quantidadeQuiabo: map['quantidade_quiabo'],
      idMaxixe: map['id_maxixe'],
      idVendaMaxixe: map['id_maxixe'],
      quantidadeMaxixe: map['quantidade_maxixe'],
      idJilo: map['id_jilo'],
      idVendaJilo: map['id_jilo'],
      quantidadeJilo: map['quantidade_jilo'],
    );
  }

  LinhaVendaDto copyWith({
    int? idPessoa,
    String? nomePessoa,
    int? idPimenta,
    int? idVendaPimenta,
    double? quantidadePimenta,
    int? idQuiabo,
    int? idVendaQuiabo,
    double? quantidadeQuiabo,
    int? idMaxixe,
    int? idVendaMaxixe,
    double? quantidadeMaxixe,
    int? idJilo,
    int? idVendaJilo,
    double? quantidadeJilo,
  }) {
    return LinhaVendaDto(
      idPessoa: idPessoa ?? this.idPessoa,
      nomePessoa: nomePessoa ?? this.nomePessoa,
      idPimenta: idPimenta ?? this.idPimenta,
      idVendaPimenta: idVendaPimenta ?? this.idVendaPimenta,
      quantidadePimenta: quantidadePimenta ?? this.quantidadePimenta,
      idQuiabo: idQuiabo ?? this.idQuiabo,
      idVendaQuiabo: idVendaQuiabo ?? this.idVendaQuiabo,
      quantidadeQuiabo: quantidadeQuiabo ?? this.quantidadeQuiabo,
      idMaxixe: idMaxixe ?? this.idMaxixe,
      idVendaMaxixe: idVendaMaxixe ?? this.idVendaMaxixe,
      quantidadeMaxixe: quantidadeMaxixe ?? this.quantidadeMaxixe,
      idJilo: idJilo ?? this.idJilo,
      idVendaJilo: idVendaJilo ?? this.idVendaJilo,
      quantidadeJilo: quantidadeJilo ?? this.quantidadeJilo,
    );
  }
}
