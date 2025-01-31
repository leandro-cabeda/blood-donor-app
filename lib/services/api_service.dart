import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'dart:html' as html;

class ApiService {
  final String baseUrl = "http://localhost:8081/api/donors"; // URL da API
  final storage =
      FlutterSecureStorage(); // Instância para armazenar as credenciais

  // Credenciais fixas
  final String username = "admin";
  final String password = "12345";

  // Método para gerar o cabeçalho Authorization com base na autenticação básica
  Map<String, String> getAuthHeaders() {
    // Codificando as credenciais para autenticação básica
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json', // Supondo que os dados sejam JSON
      "Access-Control-Allow-Origin": "*",
      "Accept": "application/json",
    };
  }

  // Requisição GET com autenticação
  Future<List<Donor>> fetchDonors() async {
    final response =
        await http.get(Uri.parse(baseUrl), headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("Data retornado: " + data.toString());
      return data.map((json) => Donor.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao carregar os doadores");
    }
  }

  // Função de upload com suporte para web e mobile
  Future<String> uploadFile(dynamic file, String fileName) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': basicAuth,
    });

    if (kIsWeb && file is Uint8List) {
      // Web: Enviar os bytes do arquivo
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file, // Agora, file é Uint8List corretamente
          filename: fileName,
          contentType: MediaType('application', 'json'),
        ),
      );
    } else if (!kIsWeb && file is File) {
      // Mobile/Desktop: Enviar via path
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path, // Agora, file é File corretamente
          filename: fileName,
          contentType: MediaType('application', 'json'),
        ),
      );
    } else {
      return "Erro: Tipo de arquivo inválido";
    }

    var response = await request.send();
    return response.statusCode == 200
        ? "Arquivo enviado!"
        : "Erro ao enviar arquivo.";
  }

  // Requisição POST com autenticação para adicionar um doador
  Future<void> postDonor(Donor donor) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await getAuthHeaders(), // Cabeçalho de autenticação
      body: json.encode(donor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Erro ao adicionar doador! Status: ${response.statusCode} - Info: ${response.body}");
    }
  }

  // Requisição GET com autenticação para obter doadores por estado
  Future<Map<String, int>> getDonorsByState() async {
    final response = await http.get(Uri.parse("$baseUrl/por-estado"),
        headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception("Erro ao buscar doadores por estado");
    }
  }

  // Outras requisições (GETs e POSTs) seguirão a mesma estrutura, com autenticação adicionada

  Future<Map<String, double>> getAverageIMCByAgeGroup() async {
    final response = await http.get(Uri.parse("$baseUrl/imc"),
        headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      return Map<String, double>.from(json.decode(response.body));
    } else {
      throw Exception("Erro ao buscar IMC médio por faixa etária");
    }
  }

  Future<Map<String, double>> getObesityPercentages() async {
    final response = await http.get(Uri.parse("$baseUrl/obesos"),
        headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      return Map<String, double>.from(json.decode(response.body));
    } else {
      throw Exception(
          "Erro ao buscar percentuais de obesidade entre homens e mulheres");
    }
  }

  Future<Map<String, double>> getAverageAgeByBloodType() async {
    final response = await http.get(
        Uri.parse("$baseUrl/idade-media-tipo-sanguineo"),
        headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      return Map<String, double>.from(json.decode(response.body));
    } else {
      throw Exception("Erro ao buscar idade média por tipo sanguíneo");
    }
  }

  Future<Map<String, int>> getDonorsByReceptors() async {
    final response = await http.get(Uri.parse("$baseUrl/quantidade-receptor"),
        headers: await getAuthHeaders());

    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception(
          "Erro ao buscar contagem de doadores por tipo sanguíneo receptor");
    }
  }
}
