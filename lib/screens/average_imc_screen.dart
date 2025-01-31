import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AverageIMCScreen extends StatefulWidget {
  @override
  AverageIMCScreenState createState() => AverageIMCScreenState();
}

class AverageIMCScreenState extends State<AverageIMCScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, double>> averageIMC;

  @override
  void initState() {
    super.initState();
    averageIMC = apiService.getAverageIMCByAgeGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("IMC Médio por Faixa Etária"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ícone de voltar
            onPressed: () {
              Navigator.pop(context); // Voltar para a tela anterior
            },
          )),
      body: FutureBuilder<Map<String, double>>(
        future: averageIMC,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          return ListView(
            children: snapshot.data!.entries.map((entry) {
              return ListTile(
                title: Text("${entry.key} anos"),
                subtitle: Text("IMC médio: ${entry.value.toStringAsFixed(2)}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
