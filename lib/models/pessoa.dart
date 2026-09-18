class Pessoa {
  String nome;
  String cep;
  String numero;
  String complemento;
  String rua;
  String bairro;
  String cidade;
  String estado;

  Pessoa({
    required this.nome,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cep': cep,
      'numero': numero,
      'complemento': complemento,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
    };
  }

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      nome: json['nome'] ?? '',
      cep: json['cep'] ?? '',
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      rua: json['rua'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
    );
  }
}
