import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DonorsByReceptorScreen extends StatefulWidget {
  @override
  DonorsByReceptorScreenState createState() => DonorsByReceptorScreenState();
}

class DonorsByReceptorScreenState extends State<DonorsByReceptorScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, int>> donorsByReceptors;

  @override
  void initState() {
    super.initState();
    donorsByReceptors = apiService.getDonorsByReceptors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doadores por cada Tipo Sanguíneo Receptor"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de voltar
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela anterior
          },
        ),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: donorsByReceptors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          return ListView(
            children: snapshot.data!.entries.map((entry) {
              return ListTile(
                title: Text("Receptor: ${entry.key}"),
                subtitle: Text("Total de Doadores: ${entry.value}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
