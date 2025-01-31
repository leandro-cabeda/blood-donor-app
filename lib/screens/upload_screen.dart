import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:path/path.dart' as path;

class UploadScreen extends StatefulWidget {
  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  final ApiService apiService = ApiService();
  File? selectedFile; // Para Mobile/Desktop
  Uint8List? selectedFileBytes; // Para Web
  String? nameFile;
  String message = "";

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: kIsWeb, // Necessário na Web para acessar os bytes
    );

    if (result != null) {
      setState(() {
        nameFile = result.files.single.name;

        if (kIsWeb) {
          // Web: Armazena os bytes diretamente
          selectedFileBytes = result.files.first.bytes;
        } else {
          // Mobile/Desktop: Usa o path para criar um File
          selectedFile = File(result.files.single.path!);
        }
      });
    }
  }

  // Função para enviar o arquivo
  Future<void> uploadFile() async {
    if (nameFile == null) return;

    String response;

    if (kIsWeb && selectedFileBytes != null) {
      // Web: Passa os bytes corretamente
      response = await apiService.uploadFile(selectedFileBytes!, nameFile!);
    } else if (!kIsWeb && selectedFile != null) {
      // Mobile/Desktop: Passa o arquivo corretamente
      response = await apiService.uploadFile(selectedFile!, nameFile!);
    } else {
      response = "Nenhum arquivo selecionado";
    }

    setState(() {
      message = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anexar Arquivo"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menu Serviços',
            onPressed: () {
              showMenu(context); // Abre o menu lateral
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text("Selecionar Arquivo"),
            ),
            SizedBox(height: 10),
            if (selectedFile != null || selectedFileBytes != null)
              Text("Arquivo uploadado!"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text("Enviar Arquivo para Processar"),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.green)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Wrap(
                spacing: 10, // Espaço horizontal entre os botões
                runSpacing: 10, // Espaço vertical entre as linhas
                children: [
                  buildButton(context, "Ver lista de Doadores", "/donors"),
                  buildButton(context, "Postar Doadores", "/post"),
                  buildButton(context, "IMC por Idade Faixa Etária", "/imc"),
                  buildButton(context, "Percentual de Obesos", "/obesity"),
                  buildButton(context, "Doadores por Estado", "/by-state"),
                  buildButton(context, "Idade Média por cada Tipo Sanguíneo",
                      "/avg-age-blood"),
                  buildButton(context, "Quantidade de Doadores por Receptor",
                      "/donors-receptor"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, String route) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 50, // Divide em 2 colunas
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  void showMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)), // Borda arredondada
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta a altura ao conteúdo
              children: [
                buildMenuItem(context, "Listar Doadores", "/donors"),
                buildMenuItem(context, "Postar Doadores", "/post"),
                buildMenuItem(context, "IMC por Idade Faixa Etária", "/imc"),
                buildMenuItem(context, "Percentual de Obesos", "/obesity"),
                buildMenuItem(context, "Doadores por Estado", "/by-state"),
                buildMenuItem(context, "Idade Média por cada Tipo Sanguíneo",
                    "/avg-age-blood"),
                buildMenuItem(context, "Quantidade de Doadores por Receptor",
                    "/donors-receptor"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMenuItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.pop(context); // Fecha o menu
        Navigator.pushNamed(context, route); // Navega para a tela selecionada
      },
    );
  }
}
