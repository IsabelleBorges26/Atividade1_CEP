import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import 'cadastro_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PessoaService pessoaService = PessoaService();

  List<Pessoa> pessoas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    final resultado = await pessoaService.listarPessoas();

    if (!mounted) return;

    setState(() {
      pessoas = resultado;
      carregando = false;
    });
  }

  Future<void> abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroScreen(),
      ),
    );

    carregarPessoas();
  }

  void abrirSplash() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
    );
  }

  void sair() {
    Navigator.pop(context);
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFF4F7),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 25),
                decoration: const BoxDecoration(
                  color: Color(0xFFE9A6B8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                      size: 45,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Pessoas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Menu do aplicativo',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_rounded),
                title: const Text('Início'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.animation_rounded),
                title: const Text('Splash'),
                onTap: () {
                  Navigator.pop(context);
                  abrirSplash();
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app_rounded),
                title: const Text('Sair'),
                onTap: sair,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Pessoas cadastradas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE9A6B8),
        foregroundColor: Colors.white,
        onPressed: abrirCadastro,
        child: const Icon(Icons.add_rounded),
      ),
      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pessoas.isEmpty
              ? _mensagemVazia()
              : RefreshIndicator(
                  color: const Color(0xFFE9A6B8),
                  onRefresh: carregarPessoas,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
                    itemCount: pessoas.length,
                    itemBuilder: (context, index) {
                      return _cardPessoa(pessoas[index]);
                    },
                  ),
                ),
    );
  }

  Widget _mensagemVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: const Color(0xFFF7DCE3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 50,
                color: Color(0xFFE09AAF),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nenhuma pessoa cadastrada',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Toque no botão + para adicionar o primeiro cadastro.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A737A)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPessoa(Pessoa pessoa) {
    final endereco =
        '${pessoa.rua}, ${pessoa.numero} - ${pessoa.bairro}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF1D5DC),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF7DCE3),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFFE09AAF),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pessoa.nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    endereco,
                    style: const TextStyle(
                      color: Color(0xFF75646A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pessoa.cidade} - ${pessoa.estado}  •  CEP ${pessoa.cep}',
                    style: const TextStyle(
                      color: Color(0xFF9A858B),
                      fontSize: 13,
                    ),
                  ),
                  if (pessoa.complemento.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      pessoa.complemento,
                      style: const TextStyle(
                        color: Color(0xFF9A858B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
