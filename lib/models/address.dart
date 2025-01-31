class Address {
  final String cep;

  final String endereco;

  final String bairro;

  final String estado;

  final String cidade;

  final num numero;

  Address({
    required this.cep,
    required this.endereco,
    required this.bairro,
    required this.estado,
    required this.cidade,
    required this.numero,
  });

  // Método para converter JSON em Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      cep: json['cep'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      estado: json['estado'],
      cidade: json['cidade'],
      numero: json['numero'],
    );
  }

  // Método para converter Address em JSON
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'endereco': endereco,
      'bairro': bairro,
      'estado': estado,
      'cidade': cidade,
      'numero': numero,
    };
  }
}
