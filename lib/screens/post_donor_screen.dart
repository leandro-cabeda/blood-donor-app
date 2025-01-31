import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donor.dart';
import '../models/address.dart';
import '../providers/donor_provider.dart';

class PostDonorScreen extends StatefulWidget {
  @override
  PostDonorScreenState createState() => PostDonorScreenState();
}

class PostDonorScreenState extends State<PostDonorScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) {
    final donorProvider = Provider.of<DonorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Doador"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de voltar
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela anterior
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text("Dados do Doador",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildTextField("Nome", "nome"),
              buildTextField("CPF", "cpf"),
              buildTextField("RG", "rg"),
              buildTextField("Sexo", "sexo"),
              buildDateField("Data de Nascimento", "dataNasc"),
              buildTextField("Nome da Mãe", "mae"),
              buildTextField("Nome do Pai", "pai"),
              buildTextField("E-mail", "email"),
              buildTextField("Telefone Fixo", "telefoneFixo"),
              buildTextField("Celular", "celular"),
              buildNumericField("Peso", "peso"),
              buildNumericField("Altura", "altura"),
              buildTextField("Tipo Sanguíneo", "tipoSanguineo"),
              const SizedBox(height: 16),
              const Text("Endereço",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildTextField("CEP", "cep"),
              buildTextField("Endereço", "endereco"),
              buildTextField("Bairro", "bairro"),
              buildTextField("Cidade", "cidade"),
              buildTextField("Estado", "estado"),
              buildNumericField("Número", "numero"),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Salvar"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final newDonor = Donor(
                      id: null,
                      nome: formData['nome'],
                      cpf: formData['cpf'],
                      rg: formData['rg'],
                      sexo: formData['sexo'],
                      dataNasc: DateTime.parse(formData['dataNasc']),
                      mae: formData['mae'],
                      pai: formData['pai'],
                      email: formData['email'],
                      telefoneFixo: formData['telefoneFixo'],
                      celular: formData['celular'],
                      peso: formData['peso'],
                      altura: formData['altura'],
                      tipoSanguineo: formData['tipoSanguineo'],
                      endereco: Address(
                        cep: formData['cep'],
                        endereco: formData['endereco'],
                        bairro: formData['bairro'],
                        cidade: formData['cidade'],
                        estado: formData['estado'],
                        numero: formData['numero'],
                      ),
                    );

                    donorProvider.postDonor(newDonor);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (value) => formData[key] = value!,
    );
  }

  Widget buildNumericField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onSaved: (value) => formData[key] = double.parse(value!),
    );
  }

  Widget buildDateField(String label, String key) {
    return buildTextField(label, key); // Apenas para simplificação
  }
}
