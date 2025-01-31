import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ObesityScreen extends StatefulWidget {
  @override
  ObesityScreenState createState() => ObesityScreenState();
}

class ObesityScreenState extends State<ObesityScreen> {
  final ApiService apiService = ApiService();
  late Future<Map<String, double>> obesityData;

  @override
  void initState() {
    super.initState();
    obesityData = apiService.getObesityPercentages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Percentual de Obesos"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ícone de voltar
            onPressed: () {
              Navigator.pop(context); // Voltar para a tela anterior
            },
          )),
      body: FutureBuilder<Map<String, double>>(
        future: obesityData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          return ListView(
            children: snapshot.data!.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text("${entry.value.toStringAsFixed(2)}%"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
