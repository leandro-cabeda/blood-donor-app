import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DonorsByStateScreen extends StatefulWidget {
  @override
  DonorsByStateScreenState createState() => DonorsByStateScreenState();
}

class DonorsByStateScreenState extends State<DonorsByStateScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, int>> donorsByState;

  @override
  void initState() {
    super.initState();
    donorsByState = apiService.getDonorsByState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Doadores por cada Estado"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ícone de voltar
            onPressed: () {
              Navigator.pop(context); // Voltar para a tela anterior
            },
          )),
      body: FutureBuilder<Map<String, int>>(
        future: donorsByState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          return ListView(
            children: snapshot.data!.entries.map((entry) {
              return ListTile(
                title: Text("Estado: ${entry.key}"),
                subtitle: Text("Total de doadores: ${entry.value}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
