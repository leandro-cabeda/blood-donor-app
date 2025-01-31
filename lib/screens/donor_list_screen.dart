import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/donor_provider.dart';
import '../models/donor.dart';

class DonorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donorProvider = Provider.of<DonorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Doadores"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de voltar
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela anterior
          },
        ),
      ),
      body: FutureBuilder(
        future: donorProvider.loadDonors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          }

          if (donorProvider.donors.isEmpty) {
            return const Center(child: Text("Nenhum doador cadastrado."));
          }

          return ListView.builder(
            itemCount: donorProvider.donors.length,
            itemBuilder: (context, index) {
              final Donor donor = donorProvider.donors[index];

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donor.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      buildDetailRow("CPF", donor.cpf),
                      buildDetailRow("RG", donor.rg),
                      buildDetailRow("Sexo", donor.sexo),
                      buildDetailRow(
                          "Data de Nascimento", donor.dataNasc.toString()),
                      buildDetailRow("Mãe", donor.mae),
                      buildDetailRow("Pai", donor.pai),
                      buildDetailRow("E-mail", donor.email),
                      buildDetailRow("Telefone", donor.telefoneFixo),
                      buildDetailRow("Celular", donor.celular),
                      buildDetailRow("Peso", donor.peso.toString()),
                      buildDetailRow("Altura", donor.altura.toString()),
                      buildDetailRow("Tipo Sanguíneo", donor.tipoSanguineo),
                      const SizedBox(height: 10),
                      const Text(
                        "Endereço",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildDetailRow("CEP", donor.endereco.cep),
                      buildDetailRow("Endereço", donor.endereco.endereco),
                      buildDetailRow("Bairro", donor.endereco.bairro),
                      buildDetailRow("Cidade", donor.endereco.cidade),
                      buildDetailRow("Estado", donor.endereco.estado),
                      buildDetailRow(
                          "Número", donor.endereco.numero.toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/post");
        },
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
