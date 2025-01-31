import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AverageAgeBloodTypeScreen extends StatefulWidget {
  @override
  AverageAgeBloodTypeScreenState createState() =>
      AverageAgeBloodTypeScreenState();
}

class AverageAgeBloodTypeScreenState extends State<AverageAgeBloodTypeScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, double>> averageAgeByBloodType;

  @override
  void initState() {
    super.initState();
    averageAgeByBloodType = apiService.getAverageAgeByBloodType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Média de Idade por Tipo Sanguíneo"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ícone de voltar
            onPressed: () {
              Navigator.pop(context); // Voltar para a tela anterior
            },
          )),
      body: FutureBuilder<Map<String, double>>(
        future: averageAgeByBloodType,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          return ListView(
            children: snapshot.data!.entries.map((entry) {
              return ListTile(
                title: Text("Tipo Sanguíneo: ${entry.key}"),
                subtitle: Text(
                    "Média de Idade: ${entry.value.toStringAsFixed(1)} anos"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
