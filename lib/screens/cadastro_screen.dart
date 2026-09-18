import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/pessoa.dart';
import '../services/cep_service.dart';
import '../services/pessoa_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final nomeController = TextEditingController();
  final cepController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  final CepService cepService = CepService();
  final PessoaService pessoaService = PessoaService();

  String rua = '';
  String bairro = '';
  String cidade = '';
  String estado = '';

  bool buscandoCep = false;

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    super.dispose();
  }

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      return;
    }

    setState(() {
      buscandoCep = true;
    });

    final dados = await cepService.buscarCep(cep);

    if (!mounted) return;

    setState(() {
      buscandoCep = false;

      if (dados != null) {
        rua = dados['logradouro'] ?? '';
        bairro = dados['bairro'] ?? '';
        cidade = dados['localidade'] ?? '';
        estado = dados['uf'] ?? '';
      } else {
        rua = '';
        bairro = '';
        cidade = '';
        estado = '';
      }
    });

    if (dados == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível encontrar esse CEP.'),
        ),
      );
    }
  }

  Future<void> salvar() async {
    if (nomeController.text.trim().isEmpty ||
        cepController.text.trim().isEmpty ||
        numeroController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha Nome, CEP e Número.'),
        ),
      );
      return;
    }

    if (rua.isEmpty || cidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha um CEP válido antes de salvar.'),
        ),
      );
      return;
    }

    final pessoa = Pessoa(
      nome: nomeController.text.trim(),
      cep: cepController.text.trim(),
      numero: numeroController.text.trim(),
      complemento: complementoController.text.trim(),
      rua: rua,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
    );

    await pessoaService.salvarPessoa(pessoa);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro salvo com sucesso!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo cadastro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo('Dados pessoais'),
            const SizedBox(height: 12),
            _campo(
              controller: nomeController,
              label: 'Nome',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 13),
            _titulo('Endereço'),
            const SizedBox(height: 12),
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: (valor) {
                if (valor.length == 8) {
                  buscarCep();
                }
              },
              onEditingComplete: buscarCep,
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: 'Digite os 8 números do CEP',
                prefixIcon: const Icon(Icons.location_on_outlined),
                suffixIcon: buscandoCep
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: buscarCep,
                        icon: const Icon(Icons.search_rounded),
                      ),
              ),
            ),
            const SizedBox(height: 13),
            _enderecoCampo('Rua', rua, Icons.home_outlined),
            const SizedBox(height: 13),
            _enderecoCampo('Bairro', bairro, Icons.place_outlined),
            const SizedBox(height: 13),
            _enderecoCampo('Cidade', cidade, Icons.location_city_outlined),
            const SizedBox(height: 13),
            _enderecoCampo('Estado', estado, Icons.map_outlined),
            const SizedBox(height: 13),
            _campo(
              controller: numeroController,
              label: 'Número',
              icon: Icons.pin_outlined,
              teclado: TextInputType.number,
            ),
            const SizedBox(height: 13),
            _campo(
              controller: complementoController,
              label: 'Complemento',
              icon: Icons.notes_outlined,
              obrigatorio: false,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: salvar,
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Salvar cadastro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9A6B8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? teclado,
    bool obrigatorio = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      decoration: InputDecoration(
        labelText: obrigatorio ? label : '$label (opcional)',
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _enderecoCampo(
    String label,
    String valor,
    IconData icon,
  ) {
    return TextField(
      controller: TextEditingController(text: valor),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF8F2F4),
      ),
    );
  }
}
