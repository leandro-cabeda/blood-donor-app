import 'package:blood_donor_app/models/address.dart';

class Donor {
  final int? id;

  final String nome;

  final String cpf;

  final String rg;

  final String sexo;

  final DateTime dataNasc;

  final String mae;

  final String pai;

  final String email;

  final String telefoneFixo;

  final String celular;

  final num peso;

  final num altura;

  final String tipoSanguineo;

  DateTime? createdAt;

  DateTime? updatedAt;

  final Address endereco;

  Donor({
    this.id,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.sexo,
    required this.dataNasc,
    required this.mae,
    required this.pai,
    required this.email,
    required this.telefoneFixo,
    required this.celular,
    required this.peso,
    required this.altura,
    required this.tipoSanguineo,
    this.createdAt,
    this.updatedAt,
    required this.endereco,
  });

  // Método para converter JSON em Donor
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      rg: json['rg'],
      sexo: json['sexo'],
      dataNasc: DateTime.parse(json['data_nasc']),
      mae: json['mae'],
      pai: json['pai'],
      email: json['email'],
      telefoneFixo: json['telefone_fixo'],
      celular: json['celular'],
      peso: json['peso'],
      altura: json['altura'],
      tipoSanguineo: json['tipo_sanguineo'],
      endereco: Address.fromJson(json['endereco']),
    );
  }

  // Método para converter Donor em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'rg': rg,
      'sexo': sexo,
      'data_nasc': dataNasc.toIso8601String(),
      'mae': mae,
      'pai': pai,
      'email': email,
      'telefone_fixo': telefoneFixo,
      'celular': celular,
      'peso': peso,
      'altura': altura,
      'tipo_sanguineo': tipoSanguineo,
      'endereco': endereco.toJson(),
    };
  }
}
